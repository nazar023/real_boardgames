class Game < ApplicationRecord
  validates_presence_of :name, :members
  has_many :participants
end
