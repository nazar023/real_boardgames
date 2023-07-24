# frozen_string_literal: true

class Profile < ApplicationRecord # :nodoc:
  validates :user_id, presence: true

  belongs_to :user
  has_many :friends
end
