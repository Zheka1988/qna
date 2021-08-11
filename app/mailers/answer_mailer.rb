class AnswerMailer < ApplicationMailer

  def digest(user, answer)
    @answer = answer
    @user = user
    mail to: user.email
  end
end