FactoryGirl.define do

  factory :question do
    sequence(:title) { |n| "Question ##{n}" }
    sequence(:body) { |n| "Text ##{n}" }
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
