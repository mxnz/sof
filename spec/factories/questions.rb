FactoryGirl.define do

  factory :question do
    user 
    sequence(:title) { |n| "Question_##{n}" }
    sequence(:body) { |n| "Text_##{n}" }
  end

  factory :invalid_question, class: "Question" do
    user
    title nil
    body nil
  end
end
