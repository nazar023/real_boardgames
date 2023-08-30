# frozen_string_literal: true

class Game < ApplicationRecord # :nodoc:
  validates :name, :members, presence: true

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :winner, class_name: 'Participant', foreign_key: 'winner_id', optional: true

  has_many :participants, dependent: :destroy
  has_many :game_invites, dependent: :destroy

  scope :with_participants, -> { includes(:participants) }
end
