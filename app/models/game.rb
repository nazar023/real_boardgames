# frozen_string_literal: true

class Game < ApplicationRecord # :nodoc:
  belongs_to :creator, class_name: 'User'

  validates :name, :members, presence: true

  has_many :participants, dependent: :destroy
end
