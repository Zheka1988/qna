class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]

  def create
    @comment = @commentable.comments.new comment_params
    @comment.save
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    @commentable = Question.find(params[:question_id])
  end
end
