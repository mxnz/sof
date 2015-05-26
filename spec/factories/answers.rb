FactoryGirl.define do

  factory :answer do
    user
    question
    sequence(:body) { |n| "Answer_##{n}" }
    best false
  end

  factory :invalid_answer, class: "Answer" do
    user
    question
    body nil
    best false
  end

end
