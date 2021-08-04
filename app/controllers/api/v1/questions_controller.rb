class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :destroy] #, :update

  authorize_resource
  def index
    @questions = Question.all

    render json: @questions
  end

  def show
    render json: @question, inlcude: [:comments, :links, :files] 
  end

  def create
    @question = current_resource_owner.authored_questions.build(question_params)
    if @question.save
      render json: @question
    else
      render json: { created_status: "The question was not created"}
    end    
  end

  def update
    @question = Question.find(params[:id])
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    render json: @question
  end

  private
  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)    
  end
end