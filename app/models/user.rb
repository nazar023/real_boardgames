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

  has_many :friendships, ->(user) { unscope(where: :sender_id).where(status: :accepted).where('sender_id = ? OR receiver_id = ?', user.id, user.id) }, class_name: 'Friendship',
                                                                                                                                                       foreign_key: 'sender_id',
                                                                                                                                                       dependent: :destroy

  has_many :friendships_reqs, -> { where(status: :pending) }, class_name: 'Friendship',
                                                                    foreign_key: 'receiver_id',
                                                                    dependent: :destroy

  has_many :friendship_send, -> { where(status: :pending) }, class_name: 'Friendship',
                                                                   foreign_key: 'sender_id',
                                                                   dependent: :destroy

  has_many :game_invites, foreign_key: 'receiver_id', dependent: :destroy

  def notifications
    game_invites + friendships_reqs
  end

  def send_friendship_request(user)
    Friendship.create!(sender_id: id, receiver_id: user.id)
  end

  def accept_friendship_request(user)
    Friendship.find_by(sender_id: user.id, receiver_id: id).accepted!
  end

  def decline_friendship_request(user)
    Friendship.find_by(sender_id: user.id, receiver_id: id).destroy
  end

  def send_game_invite(user, game)
    game.game_invites.create!(sender_id: id,
                              receiver_id: user.id,
                              game_id: game.id)
  end

  def friends_who_participates_in_game(game)
    friends = friendships.pluck(:receiver_id) + friendships.pluck(:sender_id)
    friends = friends.uniq - Array(id)
    user_participants = game.participants.pluck(:user_id).compact.uniq
    friends & user_participants
  end

  def find_eligible_friends_for_game(game)
    friendships = (self.friendships.pluck(:receiver_id) + self.friendships.pluck(:sender_id)).uniq
    friendships.delete(self.id)
    participants_users_ids = game.participants.pluck(:user_id).compact
    friendships -= participants_users_ids
    invited_to_game = GameInvite.where(game_id: game.id).pluck(:receiver_id)
    friendships -= invited_to_game
    self.friendships.where(receiver_id: friendships).or(self.friendships.where(sender_id: friendships))
  end

end
