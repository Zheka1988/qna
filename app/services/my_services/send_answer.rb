class MyServices::SendAnswer
  def send_answer(answer)
    sleep(3) #Добавил, чтобы kod не отрабатывал, пока ответ не добавиться в базу
    user = answer.question.author
    AnswerMailer.digest(user, answer).deliver_later unless Subscription.where(user_id: user.id, question_id: answer.question.id)

    answer.question.subscription do |s|
      AnswerMailer.digest(s.user, answer).deliver_later
    end
  end
end