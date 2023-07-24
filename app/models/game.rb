class Game < ApplicationRecord
  belongs_to :creator, class_name: 'User'

  validates :name, :members, presence: true
  has_many :participants
end
