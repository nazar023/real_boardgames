# frozen_string_literal: true

class GameInvite < ApplicationRecord # :nodoc:
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :game

  after_create_commit { broadcast_notifications }

  scope :with_users_avatars, -> { includes(receiver: :avatar_attachment, sender: :avatar_attachment) }

  private

  def broadcast_notifications
    GameInviteNotification.with(message: self).deliver_later(receiver)
  end

end
