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
    let(:action) { Answer.create(body: 'Test', question: question, user: author) }

    it_behaves_like "an action changing answer's author reputation"
    it_behaves_like "an action not changing the best answer's author reputation"

    it "sends email notification to question' subscribers" do
      expect(AnswerNotificationsJob).to receive(:perform_later)
      action
    end
  end

  describe '#update' do
    let!(:answer) { create(:answer) }

    context 'without changing best attribute' do
      let(:action) { answer.update(body: 'updated_body') }

      it_behaves_like "an action not changing answer's author reputation"
      it_behaves_like "an action not changing the best answer's author reputation"
    end
    context 'changing best attribute' do
      let(:author) { answer.user }
      let(:action) { answer.update(best: true) }

      it_behaves_like "an action not changing answer's author reputation"
      it_behaves_like "an action changing the best answer's author reputation"
    end
  end

  describe '#destroy' do
    let!(:answer) { create(:answer) }
    let(:author) { answer.user }
    let(:action) { answer.destroy }

    it_behaves_like "an action changing answer's author reputation"
    it_behaves_like "an action not changing the best answer's author reputation"
  end
end
