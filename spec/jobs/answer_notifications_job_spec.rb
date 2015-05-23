require 'rails_helper'

RSpec.describe AnswerNotificationsJob, type: :job do
  describe '.perform' do
    let!(:answer) { create(:answer) }
    let!(:question_author) { answer.question.user }
    let!(:subscribed_user) { create(:email_sub, question: answer.question).user }
    let!(:unsubscribed_user) { create(:user) }
    let(:perform_job) { AnswerNotificationsJob.perform_later(answer.id) }

    before { clear_emails }

    it 'sends email notification to question subscribers' do
      perform_job

      expect(all_emails.length).to eq 2

      open_email(question_author.email)
      expect(current_email).to have_link(answer.question.title)
      expect(current_email).to have_content(answer.body)

      open_email(subscribed_user.email)
      expect(current_email).to have_link(answer.question.title)
      expect(current_email).to have_content(answer.body)

      open_email(unsubscribed_user.email)
      expect(current_email).to be_nil
    end
  end
end
