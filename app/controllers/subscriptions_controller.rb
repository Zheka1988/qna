class SubscriptionsController < ApplicationController
  before_action :load_subscription, only: [:destroy]
  before_action :load_question, only: [:create]
  
  authorize_resource

  def create
    @subscription = Subscription.new(user_id: current_user.id, question_id: @question.id)
    @subscription.save
  end

  def destroy
    @question = @subscription.question
    @subscription.destroy
  end

  private
  def load_subscription
    @subscription = Subscription.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
