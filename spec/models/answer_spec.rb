require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  it { should validate_presence_of :user }
  it { should validate_presence_of :question }
  it { should validate_presence_of :body }
  
  it "the best answer should be unique for given question" do
    answer = create(:answer)
    another_answer = create(:answer, question: answer.question, best: true)

    answer.best = true
    answer.save
    another_answer.reload

    expect(answer.best).to eq true
    expect(another_answer.best).to eq false
  end
end
