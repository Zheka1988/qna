class CommentsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  
  before_action :load_commentable, only: [:create]

  after_action :publish_comment, only: [:create]
  after_action :load_question, only: [:create]

  def create
    @comment = @commentable.comments.new comment_params
    @comment.author = current_user
    @comment.save
  end

  private
  def publish_comment
    return if @comment.errors.any?
    
    
    ActionCable.server.broadcast(
      "comments_#{@question.id}",
      ApplicationController.render(
        json: { id: @comment.id,
                body: @comment.body,
                # question_user_id: @comment.question.author.id
                commentable_type: @comment.commentable_type,
                commentable_id: @commentable.id
          }
        )
      )    
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    comment = params[:comment]
    if comment[:commentable] == 'Question'
      @commentable = Question.find(params[:question_id])
      # @question = @commentable
    elsif comment[:commentable] == 'Answer'
      @commentable = Answer.find(params[:answer_id])
      # @question = @commentable.question
    end
  end

  def load_question
    if @commentable.class.name == "Question"
      @question = @commentable
    elsif @commentable.class.name == "Answer"
      @question = @commentable.question
    end
  end
end
