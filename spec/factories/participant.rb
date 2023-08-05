# frozen_string_literal: true

FactoryBot.define do
  factory :participant do
    game_id { nil }
    user_id { nil }
    sequence(:name) { |n| "Joe#{n}" }
    sequence(:number) { |n| "111111#{n}" }
  end
end
