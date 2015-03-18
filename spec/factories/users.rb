FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@test.com"
    end
    sequence :password do |n|
      "password#{n}"
    end
  end

end
