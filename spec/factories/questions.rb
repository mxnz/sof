FactoryGirl.define do

  sequence :title do |n|
    "Question ##{n}"
  end

  sequence :body do |n|
    "Text ##{n}"
  end

  factory :question do
    title
    body
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
