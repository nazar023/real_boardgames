# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    winner_id { nil }
    sequence(:name) { |n| "Game#{n}" }
    members { 6 }
    creator factory: :user
  end
end
