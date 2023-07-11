class Participant < ApplicationRecord
  validates_presence_of :name, :number
  belongs_to :game
  has_many :users

  scope :already_joined?, ->(user) { includes(id: user.id) }
end
