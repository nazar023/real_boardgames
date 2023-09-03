# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@exmp.com" }
    sequence(:username) { |n| "user#{n}" }
    sequence(:number) { |n| "11111#{n}" }
    password { 'password123' }
    password_confirmation { "password123" }
  end
end
