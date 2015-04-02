require 'rails_helper'

RSpec.describe Attachment do
  it { should belong_to :attachable }
  it { should validate_presence_of :file }
end
