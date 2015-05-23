require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'a votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:email_subs).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :user }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '.create' do
    let!(:author) { create(:user) }
    let(:create_question) { create(:question, user: author) }

    it 'creates new email sub for author' do
      expect { create_question }.to change(author.email_subs, :count).by 1
    end

    it 'creates email sub for question' do
      question = create_question
      expect(question.email_subs.count).to eq 1
    end
  end
end
