# frozen_string_literal: true

class User < ApplicationRecord # :nodoc:
  has_secure_password
  validates :email, :username, presence: true

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :number, with: ->(number) { number.strip }

  has_many :games, inverse_of: :creator, foreign_key: 'creator_id', dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :api_tokens, dependent: :destroy
  enum status: %i[offline online]
  enum subscription_type: %i[no_subscription knight king]

  after_create { add_stripe_customer_id }
  before_destroy { delete_stripe_customer }

  has_many :friendships, ->(user) { unscope(where: :sender_id).where(status: :accepted).where('sender_id = ? OR receiver_id = ?', user.id, user.id) }, class_name: 'Friendship',
                                                                                                                                                       foreign_key: 'sender_id',
                                                                                                                                                       dependent: :destroy

  has_many :friendships_reqs, -> { where(status: :pending) }, class_name: 'Friendship',
                                                              foreign_key: 'receiver_id',
                                                              dependent: :destroy

  has_many :friendships_send, -> { where(status: :pending) }, class_name: 'Friendship',
                                                              foreign_key: 'sender_id',
                                                              dependent: :destroy

  has_many :game_invites, foreign_key: 'receiver_id', dependent: :destroy

  generates_token_for (:password_reset), expires_in: 15.minutes do
    password_salt&.last(10)
  end

  def friendships_users
    friendships.map do |friendship|
      friendship.sender.id == id ? friendship.receiver : friendship.sender
    end
  end

  def winrate
    value = ((wins_count / Float(games_count)) * 100).round(1)
    value.nan? ? 0 : value
  end

  def send_friendship_request(user)
    Friendship.create!(sender_id: id, receiver_id: user.id)
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
    eligible_friendships = (friendships.pluck(:receiver_id) + friendships.pluck(:sender_id)).compact.uniq - Array(id)
    invited_to_game = GameInvite.where(game_id: game.id).pluck(:receiver_id)
    eligible_friendships -= invited_to_game
    eligible_friendships -= friends_who_participates_in_game(game)
    friendships.where(receiver_id: eligible_friendships).or(friendships.where(sender_id: eligible_friendships))
  end

  private

  def add_stripe_customer_id
    update(stripe_customer_id: Stripe::Customer.create(email:))
  end

  def delete_stripe_customer
    Stripe::Customer.delete(stripe_customer_id)
  end
end
