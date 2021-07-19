class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments"
  end

  def start_st_comments(data)
    stream_from "comments_#{data['question_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
