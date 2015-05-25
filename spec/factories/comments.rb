FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "Comment_##{n}" }
    commentable nil
    user
  end

  factory :invalid_comment, class: Comment do
    body nil
    commentable nil
    user
  end
end
