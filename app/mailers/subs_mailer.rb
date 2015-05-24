class SubsMailer < ApplicationMailer

  def questions_digest_email(subscription_id, body)
    subscription = Subscription.includes(:user).find(subscription_id)
    email = subscription.user.email
    mail to: email,
         subject: 'Questions digest',
         body: body,
         content_type: 'text/html'
    subscription.update(sent_at: Time.now.utc)
  end


  def self.questions_digest_body(today)
    yesterday = today - 1
    date_range = yesterday...today
    questions = Question.where(created_at: date_range)
    return nil if questions.blank?
    self.questions_digest_example(questions).message.body.raw_source
  end

  def questions_digest_example(questions)
    @questions = questions
    mail to: 'nobody@nowhere.com',
         subject: 'Template'
  end


  def answer_notification_email(subscription_id, body)
    subscription = Subscription.includes(:user).find(subscription_id)
    email = subscription.user.email
    mail to: email,
         subject: 'New answer to subscribed question',
         body: body,
         content_type: 'text/html'
    subscription.update(sent_at: Time.now.utc)
  end

  def self.answer_notification_body(answer)
    self.answer_notification_example(answer).message.body.raw_source
  end

  def answer_notification_example(answer)
    @answer = answer
    @question = answer.question
    mail to: 'nobody@nowhere.com',
         subject: 'Template'
  end
end
