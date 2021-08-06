class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    MyServices::DailyDigest.new.send_digest
  end
end
