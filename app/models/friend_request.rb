# frozen_string_literal: true

class FriendRequest < ApplicationRecord # :nodoc:
  validates :username, :number, :friend_id, :profile_id, presence: true

  belongs_to :profile
  has_one_attached :avatar
end
