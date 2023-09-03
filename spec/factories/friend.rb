# frozen_string_literal: true

FactoryBot.define do
  factory :friend, aliases: [:friendship] do
    receiver factory: :user
    sender factory: :user
    request { false }
  end
end
