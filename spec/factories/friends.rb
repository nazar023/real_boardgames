# frozen_string_literal: true

FactoryBot.define do
  factory :friend do
    user_id { nil }
    whoSent_id factory: :user
    username { "MyString" }
    number { "MyString" }
    request { true }
  end
end
