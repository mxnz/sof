require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should validate_presence_of :user }
  it { should validate_presence_of :votable }
  it { should validate_inclusion_of(:votable_type).in_array(['Question', 'Answer']) }
  it { should have_readonly_attribute :up }

  describe '.create' do
    context 'when votable is a question' do

    end

    context 'when votable is an answer' do
    end
  end
end
