# frozen_string_literal: true

class Participant < ApplicationRecord # :nodoc:
  validates :name, :number, presence: true

  belongs_to :user, optional: true
  belongs_to :game

  has_noticed_notifications
  after_create_commit { broadcast_notifications }

  private

  def broadcast_notifications
    return if user == game.creator

    if game.game_invites.pluck(:receiver_id).include?(self.user.id)
      self.user.notifications.each do |notification|
        params = notification.to_notification
        notification.destroy if params.params[:message].game == game
      end
    end

    ParticipantNotification.with(message: self).deliver_later(game.creator)
  end
end
