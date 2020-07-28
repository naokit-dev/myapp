FactoryBot.define do
  factory :user do
    username {"test_user"}
    sequence(:email) { |n| "test_user_#{n}@example.com" }
    password {"password"}
    password_confirmation {"password"}
  end

end