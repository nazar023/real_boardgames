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

  after_create_commit { broadcast_to_game }

  private

  def broadcast_to_game
    return if game.creator == user
    broadcast_update_to 'games',
                        target: 'participants_counter',
                        html: self.game.participants.count

    broadcast_update_to "#{dom_id(game)}",
                        target: 'participants_counter',
                        html: self.game.participants.count

    if self.guest?
      broadcast_update_to "#{dom_id(game)}",
                          target: 'guest_form',
                          partial: 'participants/new_guest',
                          locals: { game: game, participant: Participant.new }
    else
      broadcast_update_to "#{dom_id(game)}",
                          target: 'user_guest_form',
                          partial: 'participants/new_guest_user',
                          locals: { user: self.creator ,game: game, participant: Participant.new }
    end

    broadcast_append_to "#{dom_id(game)}",
                        target: 'participants',
                        partial: 'participants/participant',
                        locals: { participant: self, game: self.game}

    broadcast_update_to "#{dom_id(game)}",
                        target: 'win_selector',
                        partial: 'participants/win_selector',
                        locals: { participants: self.game.participants, game: self.game}

    if self.game.participants.count == self.game.members && self.game.winner.blank?
      broadcast_remove_to "#{dom_id(game)}",
                          target: 'joining'
    end


    return unless self.user

    broadcast_remove_to "#{dom_id(game)}",
                        target: "#{dom_id(game)}_#{dom_id(self.user)}_join_button"

    broadcast_remove_to "#{dom_id(game)}",
                        target: "user_#{user.id}"
  end

  def broadcast_notifications
    return if user == game.creator

    ParticipantNotification.with(message: self).deliver_later(game.creator)

    return unless self.user

    if game.game_invites.pluck(:receiver_id).include?(self.user.id)
      self.user.notifications.each do |notification|
        params = notification.to_notification
        notification.destroy if params.params[:message].game == game
      end
    end

  end
end
