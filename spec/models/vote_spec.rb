require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should validate_presence_of :user }
  it { should validate_presence_of :votable }
  it { should validate_inclusion_of(:votable_type).in_array(['Question', 'Answer']) }
  it { should have_readonly_attribute :up }

  describe '.create' do
    let!(:user) { create(:user) }

    context 'when votable is a question' do
      it_behaves_like "an action changing votable's author reputation" do
        let!(:question) { create(:question) }
        let(:author) { question.user }
        let(:action) { Vote.create(votable: question, user: user, up: true) }
      end
    end

    context 'when votable is an answer' do
      it_behaves_like "an action changing votable's author reputation" do
        let!(:answer) { create(:answer) }
        let(:author) { answer.user }
        let(:action) { Vote.create(votable: answer, user: user, up: true) }
      end
    end
  end

  describe '.destroy' do
    context 'when votable is a question' do
      it_behaves_like "an action changing votable's author reputation" do
        let!(:question) { create(:question) }
        let!(:vote) { create(:vote, votable: question) }
        let(:author) { question.user }
        let(:action) { vote.destroy }
      end
    end

    context 'when votable is an answer' do
      it_behaves_like "an action changing votable's author reputation" do
        let!(:answer) { create(:answer) }
        let!(:vote) { create(:vote, votable: answer) }
        let(:author) { answer.user }
        let(:action) { vote.destroy }
      end
    end
  end

end
