class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.find_each do |q|
      q.created_at.strftime("%Y-%m-%d") == Date.today.strftime("%Y-%m-%d") ? q : next
    end
    mail to: user.email
  end
end
