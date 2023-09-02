# frozen_string_literal: true

class Friend < ApplicationRecord # :nodoc:
  belongs_to :receiver, class_name: 'User', inverse_of: :friends_reqs, foreign_key: 'receiver_id'
  belongs_to :sender, class_name: 'User', inverse_of: :friends, foreign_key: 'sender_id'

  scope :with_users_avatars, -> { includes(receiver: :avatar_attachment, sender: :avatar_attachment) }
  scope :not_request, -> { where(request: false) }
end
