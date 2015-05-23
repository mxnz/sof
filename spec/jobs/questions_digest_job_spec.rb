require 'rails_helper'

RSpec.describe QuestionsDigestJob, type: :job do
  
  describe '.perform' do
    let(:questions) { create_list(:question, 3) }
    let(:send_digest) { QuestionsDigestJob.perform_later }

    context 'when there are questions created yesterday' do
      before do
        questions[0].update(created_at: questions[0].created_at.to_date - 2)
        questions[1].update(created_at: questions[1].created_at.to_date - 1)
        questions[2].update(created_at: questions[2].created_at.to_date - 1)

        clear_emails
        send_digest
      end

      it 'sends email to all users' do
        expect(all_emails.length).to eq User.count
      end

      it 'sends email with questions created during the previous day' do
        users = User.all
        users.each do |u|
          open_email(u.email)
          expect(current_email).to_not have_link(questions[0].title)
          expect(current_email).to have_link(questions[1].title)
          expect(current_email).to have_link(questions[2].title)
        end
      end

      it 'updates sent_at attribute of email_subs to questions digest' do
        digest_subs = EmailSub.where(question_id: nil).ids.sort
        sent_subs = EmailSub.where('sent_at > :today', today: Time.now.utc.to_date).ids.sort
        expect(digest_subs).to eq sent_subs
      end

      it 'sends only one questions digest for user in day' do
        expect { send_digest }.to_not change { all_emails.length }
      end
    end

    context 'when there are no questions created yesterday' do
      before do
        questions[0].update(created_at: questions[0].created_at - 2)
        questions[1].update(created_at: questions[1].created_at - 1)
        questions[2].update(created_at: questions[2].created_at - 1)

        clear_emails
        send_digest
      end

      it 'sends nothing' do
        expect(ActionMailer::Base.deliveries).to be_blank  
      end
    end
  end
end
