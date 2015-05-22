class QuestionsDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    today = Time.now.utc.to_date
    body = SubsMailer.questions_digest_body(today) #questions_digest_body(today)
    return if body.blank?
    email_subs = EmailSub.where(question_id: nil).where("coalesce(sent_at, '1970-01-01') < :today", today: today).find_each do |email_sub|
      SubsMailer.questions_digest_email(email_sub.id, body).deliver_later
    end
  end
end
