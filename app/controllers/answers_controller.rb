class AnswersController < ApplicationController
  include Voitinged
  
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update, :best]

  after_action :publish_answer, only: [:create]
  
  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      flash[:notice] = "Only author the answer can change the answer!"
      redirect_to @answer.question
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      flash[:notice] = "Only author the answer can delete the answer!"
    end
  end

  def best
    if current_user.author_of?(@question)
      @answer.choose_best_answer
      flash[:notice] = "the best answer is chosen"
    else
      flash[:notice] = "Shoose best answer for the question can only author the question!"
    end
  end

  private
  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                    links_attributes: [:name, :url] )
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
    return if @answer.errors.any?

    files = {}
    @answer.files.each_with_index do |f, index|
      file = Hash.new
      file[:id] = f.id
      file[:file_name] = f.filename.to_s
      file[:file_url] = rails_blob_path(f, only_path: true)
      files[index] = file
    end

    links = {}
    @answer.links.each_with_index do |l, index|
      link = Hash.new
      link[:id] = l.id
      link[:name] = l.name
      link[:url] = l.url
      links[index] = link
    end

    ActionCable.server.broadcast(
      "answers_#{@question.id}",
      ApplicationController.render(
        json: { id: @answer.id,
                body: @answer.body,
                voitings: @answer.voitings,
                links: links,
                files: files,
                question_user_id: @answer.question.author.id
        }
      )
    )
  end
end
