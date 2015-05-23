class AnswerNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(answer_id)
    answer = Answer.find(answer_id)
    body = SubsMailer.answer_notification_body(answer)
    email_subs = EmailSub.where(question_id: answer.question_id).find_each do |email_sub|
      SubsMailer.answer_notification_email(email_sub.id, body).deliver_later
    end
  end
end
