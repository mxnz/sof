FactoryGirl.define do

  factory :answer do
    user
    question
    sequence(:body) { |n| "Answer ##{n}" }
  end

  factory :invalid_answer, class: "Answer" do
    user
    question
    body nil
  end

end
