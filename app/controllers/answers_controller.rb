class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update, :best]
  
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
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
