# frozen_string_literal: true

class GameInvite < ApplicationRecord # :nodoc:
  belongs_to :whoGet, class_name: 'User', foreign_key: 'whoGet_id'
  belongs_to :whoSent, class_name: 'User', foreign_key: 'whoSent_id'
  belongs_to :game

  after_create_commit { broadcast_notifications }

  scope :with_users_avatars, -> { includes(whoGet: :avatar_attachment, whoSent: :avatar_attachment) }

  private

  def broadcast_notifications
    GameInviteNotification.with(message: self).deliver_later(whoGet)
  end

end
