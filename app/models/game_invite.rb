# frozen_string_literal: true

class GameInvite < ApplicationRecord # :nodoc:
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :game

  scope :with_users_avatars, -> { includes(receiver: :avatar_attachment, sender: :avatar_attachment) }

  def accept
    return unless game && GamePolicy.new(nil, game).full?

    game.participants.create!(name: receiver.username,
                              number: receiver.number,
                              user: receiver)
  end

  def decline
    @game_invite.destroy
  end
end

