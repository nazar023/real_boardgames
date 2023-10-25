# frozen_string_literal: true

class GameInvite < ApplicationRecord # :nodoc:
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :game

  scope :with_users_avatars, -> { includes(receiver: :avatar_attachment, sender: :avatar_attachment) }

  after_create_commit { create_notification }


  def accept
    return unless game && game.winner.blank? && GamePolicy.new(nil, game).full?

    game.participants.create!(name: receiver.username,
                              number: receiver.number,
                              user: receiver)
  end

  def decline
    destroy
  end

  private

  def create_notification
    Notification.create(user_id: receiver.id, subject_type: self.class, subject_id: id)
  end

end

