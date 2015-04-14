require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:question) { create(:question) }
  let(:vote) { build(:vote, votable: question) }

  it { should belong_to :votable }
  it { should validate_presence_of :user }
  it { should validate_presence_of :votable }
  it { should have_readonly_attribute :up }

  context 'saving a new vote' do
    context 'when up is true' do
      it "should increment its question's rating" do
        vote.up = true
        expect { vote.save! }.to change { question.reload.rating }.by(1)
      end
    end

    context 'when up is false' do
      it "should decrement its question's rating" do
        vote.up = false
        expect { vote.save! }.to change { question.reload.rating }.by(-1)
      end
    end

    context 'when exist another vote from the same user and the same question' do
      before { create(:vote, user: vote.user, votable: vote.votable) }
      it 'should not be successfull' do
        expect { vote.save! }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  context 'destroying a vote' do
    context 'when up is true' do
      before do
        vote.up = true
        vote.save!
      end
      it "should decrement its question's rating" do
        expect { vote.destroy! }.to change { question.reload.rating }.by(-1)
      end
    end

    context 'when up is false' do
      before do
        vote.up = false
        vote.save!
      end
      it "should increment its question's rating" do
        expect { vote.destroy! }.to change { question.reload.rating }.by(1)
      end
    end
  end
end
