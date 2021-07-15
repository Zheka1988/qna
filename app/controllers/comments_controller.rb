class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]

  def create
    @comment = @commentable.comments.new comment_params
    @comment.author = current_user
    @comment.save
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    comment = params[:comment]
    if comment[:commentable] == 'Question'
      @commentable = Question.find(params[:question_id])
    elsif comment[:commentable] == 'Answer'
      @commentable = Answer.find(params[:answer_id])
    end
  end
end
