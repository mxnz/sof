FactoryGirl.define do

  factory :question do
    user 
    sequence(:title) { |n| "Question ##{n}" }
    sequence(:body) { |n| "Text ##{n}" }
  end

  factory :invalid_question, class: "Question" do
    user
    title nil
    body nil
  end
end
