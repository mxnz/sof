RSpec.shared_examples "a votable" do
  let!(:votable_factory_name) { described_class.name.downcase.to_sym }
  let(:votable) { create(votable_factory_name) }
  let(:vote) { build(:vote, votable: votable) }

  it { should have_readonly_attribute :rating }
  it { should have_many(:votes).dependent(:destroy) }

  context 'saving a new vote on it' do
    context 'when up is true' do
      it "should increment its rating" do
        vote.up = true
        expect { vote.save! }.to change { votable.reload.rating }.by(1)
      end
    end

    context 'when up is false' do
      it "should decrement its rating" do
        vote.up = false
        expect { vote.save! }.to change { votable.reload.rating }.by(-1)
      end
    end

    context 'when exist another vote from the same user and the same votable' do
      before { create(:vote, user: vote.user, votable: vote.votable) }

      it "its vote should not be valid" do
        expect(vote).to_not be_valid
      end

      it 'saving vote without validation should not be successfull' do
        expect { vote.save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end

    context 'when user try to vote for his own question' do
      before { vote.user = votable.user }
      it 'should not be valid' do
        expect(vote).to_not be_valid
      end
    end
  end

  context 'destroying its vote' do
    context 'when up is true' do
      before do
        vote.up = true
        vote.save!
      end
      it "should decrement its rating" do
        expect { vote.destroy! }.to change { votable.reload.rating }.by(-1)
      end
    end

    context 'when up is false' do
      before do
        vote.up = false
        vote.save!
      end
      it "should increment its rating" do
        expect { vote.destroy! }.to change { votable.reload.rating }.by(1)
      end
    end
  end

end
