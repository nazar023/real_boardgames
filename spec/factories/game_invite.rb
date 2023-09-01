# frozen_string_literal: true

FactoryBot.define do
  factory :game_invite do
    whoSent factory: :user
    whoGet factory: :user
    game factory: :game
  end
end
