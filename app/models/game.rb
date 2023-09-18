# frozen_string_literal: true

class Game < ApplicationRecord # :nodoc:
  include ActionView::RecordIdentifier

  validates :name, :members, presence: true

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :winner, class_name: 'Participant', foreign_key: 'winner_id', optional: true

  has_many :participants, dependent: :delete_all
  has_many :game_invites, dependent: :delete_all

  after_create_commit { create_creator_participant }

  scope :with_participants, -> { includes(:participants) }

  def finish(winner_participant)
    self.winner = winner_participant

    winner.user.increment!(:wins_count) if winner&.user
    game_invites.each(&:destroy)

    participants.where.not(user_id: nil).each do |participant|
      User.find(participant.user_id).increment!(:games_count)
    end

  end

  private

  def create_creator_participant
    participants.create!(name: creator.username,
                         number: creator.number,
                         user_id: creator.id)
  end
end
