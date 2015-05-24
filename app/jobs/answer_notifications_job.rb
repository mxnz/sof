class AnswerNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(answer_id)
    answer = Answer.find(answer_id)
    body = SubsMailer.answer_notification_body(answer)
    subscriptions = Subscription.where(question_id: answer.question_id).find_each do |subscription|
      SubsMailer.answer_notification_email(subscription.id, body).deliver_later
    end
  end
end
