# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@exmp.com" }
    username { 'B0nd' }
    password { 'pasword123' }
    number { '312312' }
  end
end
