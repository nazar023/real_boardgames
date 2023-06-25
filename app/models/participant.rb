class Participant < ApplicationRecord
  validates_presence_of :name, :number
  belongs_to :game
end
