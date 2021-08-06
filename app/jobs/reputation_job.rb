class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    MyServices::Reputation.calculate(object)
  end
end
