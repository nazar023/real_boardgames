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

  has_many :friends_reqs, ->(user) { unscope(where: :receiver_id).where('sender_id = ? AND request = true OR receiver_id = ? AND request = true', user.id, user.id) }, class_name: 'Friend',
                                                                                                                                                                       foreign_key: 'receiver_id',
                                                                                                                                                                       dependent: :destroy

  has_many :friends, ->(user) { unscope(where: :sender_id).where('sender_id = ? AND request = false OR receiver_id = ? AND request = false', user.id, user.id) }, class_name: 'Friend',
                                                                                                                                                                  foreign_key: 'sender_id',
                                                                                                                                                                  dependent: :destroy


  has_many :game_invites, foreign_key: 'receiver_id', dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy

  def send_game_invite(user, game)
    game.game_invites.create!(sender_id: self.id,
                              receiver_id: user.id,
                              game_id: game.id)
  end

end
