# frozen_string_literal: true

FactoryBot.define do
  factory :participant do
    game { nil }
    user factory: :user
    name { user.username }
    number { user.number }
  end
end
