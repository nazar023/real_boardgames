# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    receiver factory: :user
    sender factory: :user
    status { "pending" }
  end
end
