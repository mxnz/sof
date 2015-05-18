require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'a votable'

  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :user }
  it { should validate_presence_of :question }
  it { should validate_presence_of :body }
  
  it "the best answer should be unique for given question" do
    answer = create(:answer)
    another_answer = create(:answer, question: answer.question, best: true)

    answer.update!(best: true)

    expect(answer.best).to eq true
    expect(another_answer.reload.best).to eq false
  end

  describe '.create' do
    let(:author) { create(:user) }
    let(:question) { create(:question) }
    let(:create_answer) { Answer.create(body: 'Test', question: question, user: author) }

    it "invokes Reputaion.update_after_answer method" do
      expect(Reputation).to receive(:update_after_answer)
      create_answer
    end

    it "changes answer's author rating by Reputation.after_answer(...) value" do
      allow(Reputation).to receive(:after_answer).and_return(10)
      expect { create_answer }.to change { author.reload.rating }.by(10)
    end
  end

  describe '#update' do
    let!(:answer) { create(:answer) }
    
    it "doesn't invoke Reputation.update_after_answer method" do
      expect(Reputation).to_not receive(:update_after_answer)
      answer.update(body: 'updated body')
    end
  end

  describe '#destroy' do
    let!(:answer) { create(:answer) }
    let(:destroy_answer) { answer.destroy }

    it "invokes Reputaion.update_after_answer method" do
      expect(Reputation).to receive(:update_after_answer)
      destroy_answer
    end

    it "changes answer's author rating by Reputation.after_answer(...) value" do
      allow(Reputation).to receive(:after_answer).and_return(-10)
      expect { destroy_answer }.to change { answer.user.reload.rating }.by(-10)
    end

  end
end
