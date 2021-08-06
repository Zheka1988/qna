class SendAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    MyServices::SendAnswer.new.send_answer(answer)
  end
end