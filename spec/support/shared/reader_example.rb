RSpec.shared_examples 'a reader' do
  it { should be_able_to :read, Question }
  it { should be_able_to :read, Answer }
  it { should be_able_to :read, Comment }
end
