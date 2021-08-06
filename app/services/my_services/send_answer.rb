class MyServices::SendAnswer
  def send_answer(answer)
    user = answer.question.author

    AnswerMailer.digest(user, answer).deliver_later
  end
end