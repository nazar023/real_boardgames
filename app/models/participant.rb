# frozen_string_literal: true

class Participant < ApplicationRecord # :nodoc:
  include ActionView::RecordIdentifier
  validates :name, :number, presence: true

  belongs_to :user, optional: true
  belongs_to :creator, class_name: 'User', optional: true
  belongs_to :game
  enum created_by: [ :guest, :user ]

  has_noticed_notifications
  after_create_commit { broadcast_notifications }
  after_create_commit { delete_game_invite_notifications }

  private

  def broadcast_notifications
    return if user == game.creator

    ParticipantNotification.with(message: self).deliver_later(game.creator)
  end

  def delete_game_invite_notifications
    return unless user && game.game_invites.pluck(:receiver_id).include?(user.id)

    user.notifications.each do |notification|
      params = notification.to_notification
      notification.destroy if params.params[:message].game == game
    end
  end

end
