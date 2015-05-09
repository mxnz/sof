require 'rails_helper'

RSpec.shared_examples 'a guest' do
  it { should be_able_to :read, Question }
  it { should be_able_to :read, Answer }
  it { should be_able_to :read, Comment }
end
