class AnswersChannel < ApplicationCable::Channel

  def subscribed
    stream_from "answers"
  end

  def start_st_answers(data)
    stream_from "answers_#{data['question_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
