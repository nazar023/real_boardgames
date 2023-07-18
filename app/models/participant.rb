class Participant < ApplicationRecord
  validates :name, :number, presence: true

  belongs_to :game

  has_one_attached :avatar
  has_many :users
end
