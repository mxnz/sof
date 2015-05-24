class QuestionsDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    today = Time.now.utc.to_date
    body = SubsMailer.questions_digest_body(today)
    return if body.blank?
    Subscription.to_questions_digest_not_sent_after(today).find_each do |subscription|
      SubsMailer.questions_digest_email(subscription.id, body).deliver_later
    end
  end
end
