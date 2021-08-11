class QuestionsController < ApplicationController
  include Voitinged
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: %i[show edit update destroy subscribe unsubscribe]
  after_action :publish_question, only: [:create]

  before_action :gon_question, only: [:show]

  authorize_resource
  
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    @subscription = Subscription.find_by(user_id: current_user.id, question_id: @question.id) if current_user
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def edit
  end

  def create
    @question = current_user.authored_questions.build(question_params)
    if @question.save
      Subscription.create!(user_id: current_user.id, question_id: @question.id)
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private
  def gon_question
    gon.question_id = @question.id
  end
  
  def publish_question
    return if @question.errors.any?
    
    files = {}
    @question.files.each_with_index do |f, index|
      file = Hash.new
      file[:id] = f.id
      file[:file_name] = f.filename.to_s
      file[:file_url] = rails_blob_path(f, only_path: true)
      files[index] = file
    end

    links = {}
    @question.links.each_with_index do |l, index|
      link = Hash.new
      link[:id] = l.id
      link[:name] = l.name
      link[:url] = l.url
      links[index] = link
    end

    reward = {}
    if @question.reward
      reward[:id] = @question.reward.id
      reward[:name] = @question.reward.name
      reward[:url_file] = rails_blob_path(@question.reward.file, only_path: true)
    end
    renderer = ApplicationController.renderer_with_signed_in_user(current_user)

    ActionCable.server.broadcast(
      'questions',
      renderer.render(
        json: { id: @question.id,
                title: @question.title,
                body: @question.body, 
                files: files,
                links: links,
                reward: reward
              }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                      links_attributes: [:name, :url],
                                      reward_attributes: [:name, :file],
                                      comment_attributes: [:body] )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
