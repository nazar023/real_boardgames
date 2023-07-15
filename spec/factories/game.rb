# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    name { 'GOT' }
    members { 6 }
    creator factory: :user
  end
end
