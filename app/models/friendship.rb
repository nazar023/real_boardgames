# frozen_string_literal: true

class Friendship < ApplicationRecord # :nodoc:
  belongs_to :receiver, class_name: 'User', inverse_of: :friendships_reqs, foreign_key: 'receiver_id'
  belongs_to :sender, class_name: 'User', inverse_of: :friendships, foreign_key: 'sender_id'
  enum status: [ :pending, :accepted ]

  scope :with_users_avatars, -> { includes(receiver: :avatar_attachment, sender: :avatar_attachment) }
  # scope :not_request, -> { where(request: false) }
end
