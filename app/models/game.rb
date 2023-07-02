class Game < ApplicationRecord
  belongs_to :creator, class_name: "User"

  validates_presence_of :name, :members
  has_many :participants
end
