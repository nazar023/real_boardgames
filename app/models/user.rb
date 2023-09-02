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

  has_many :friends_reqs, class_name: 'Friend', foreign_key: 'receiver_id', dependent: :destroy
  has_many :friends, class_name: 'Friend', foreign_key: 'sender_id', dependent: :destroy

  has_many :game_invites, foreign_key: 'receiver_id', dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy


end
