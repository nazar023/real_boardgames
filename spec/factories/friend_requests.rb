FactoryBot.define do
  factory :friend_request do
    username { "MyString" }
    number { "MyString" }
    friend_id { 1 }
    profile_id { 1 }
  end
end
