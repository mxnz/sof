FactoryGirl.define do
  factory :vote do
    user
    up true
    votable nil
  end

end
