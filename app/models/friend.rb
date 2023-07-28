# frozen_string_literal: true

class Friend < ApplicationRecord # :nodoc:
  validates :username, :number, :user_id, presence: true

  belongs_to :profile
  has_one_attached :avatar
end
