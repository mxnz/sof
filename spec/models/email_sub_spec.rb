require 'rails_helper'

RSpec.describe EmailSub, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  it { should validate_presence_of :user }
end
