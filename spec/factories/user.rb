# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@exmp.com" }
    password { 'pasword123' }
  end
end
