class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    date = Date.today
    @questions = Question.all.where('created_at >= ? and created_at <=?', date.midnight, date.end_of_day)

    mail to: user.email
  end
end
