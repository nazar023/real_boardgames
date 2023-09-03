# frozen_string_literal: true

class User < ApplicationRecord # :nodoc:
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, :number, presence: true

  has_many :games, inverse_of: :creator, foreign_key: 'creator_id', dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  has_many :participants, dependent: :destroy

  has_many :friends_reqs, -> { where(request: true) }, class_name: 'Friend',
                                                       foreign_key: 'receiver_id',
                                                       dependent: :destroy

  has_many :friends, ->(user) { unscope(where: :sender_id).where(request: false).where('sender_id = ? OR receiver_id = ?', user.id, user.id) }, class_name: 'Friend',
                                                                                                                                                foreign_key: 'sender_id',
                                                                                                                                                dependent: :destroy


  has_many :game_invites, foreign_key: 'receiver_id', dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy

  def send_game_invite(user, game)
    game.game_invites.create!(sender_id: self.id,
                              receiver_id: user.id,
                              game_id: game.id)
  end

  def accept_game_invite(user, game)
    self.notifications.where(type: GameInviteNotification.name).each do |notification|
      game_invite = notification.to_notification.params[:message]
      next unless game_invite.sender == user && game_invite.receiver == self && game_invite.game == game

      Participant.create!(name: self.username,
                          number: self.number,
                          user_id: self.id,
                          game_id: game.id)

      game_invite.destroy
      notification.destroy
    end
  end

  def decline_game_invite(user, game)
    self.notifications.where(type: GameInviteNotification.name).each do |notification|
      game_invite = notification.to_notification.params[:message]
      next unless game_invite.sender == user && game_invite.receiver == self && game_invite.game == game

      game_invite.destroy
      notification.destroy
    end
  end

end
