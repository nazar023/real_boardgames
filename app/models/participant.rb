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

    ParticipantNotification.with(message: self).deliver_later(game.creator)
  end
end
