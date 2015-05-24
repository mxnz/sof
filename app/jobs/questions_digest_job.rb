class QuestionsDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    today = Time.now.utc.to_date
    body = SubsMailer.questions_digest_body(today)
    return if body.blank?
    email_subs = EmailSub.to_questions_digest_not_sent_after(today).find_each do |email_sub|
      SubsMailer.questions_digest_email(email_sub.id, body).deliver_later
    end
  end
end
