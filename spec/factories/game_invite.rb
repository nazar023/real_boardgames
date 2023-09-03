# frozen_string_literal: true

FactoryBot.define do
  factory :game_invite do
    sender factory: :user
    receiver factory: :user
    game factory: :game
  end
end
