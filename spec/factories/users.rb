FactoryBot.define do
  factory :user do
    username {"test_user"}
    email {"test_user@mail.com"}
    password {"password"}
    password_confirmation {"password"}
  end
end