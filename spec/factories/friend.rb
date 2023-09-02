# frozen_string_literal: true

FactoryBot.define do
  factory :friend do
    receiver_id { nil }
    sender_id factory: :user
    request { false }
  end
end
