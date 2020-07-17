FactoryBot.define do
  factory :user, class: User do
    username {"test_user"}
    email {"test_user@mail.com"}
    password {"password"}
    password_confirmation {"password"}
  end
  factory :existed_user, class: User do
    username { "existed_user" }
    email { "existed_user@email.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end