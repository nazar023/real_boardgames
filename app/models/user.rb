# frozen_string_literal: true

class User < ApplicationRecord # :nodoc:
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :games, inverse_of: :creator

  validates :username, :number, presence: true

  has_one :profile
  has_one_attached :avatar
  has_many :friends
  has_many :friend_requests

end
