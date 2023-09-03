# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    sequence(:name) { |n| "Game#{n}" }
    members { 6 }
    creator factory: :user
    winner { nil }
  end
end
