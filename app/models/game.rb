# frozen_string_literal: true

class Game < ApplicationRecord # :nodoc:
  validates :name, :members, presence: true

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :winner, class_name: 'Participant', foreign_key: 'winner_id', optional: true

  has_many :participants, dependent: :delete_all
  has_many :game_invites, dependent: :delete_all

  after_create_commit { create_creator_participant }

  after_create_commit { broadcast_to_all }
  after_update_commit { update_to_all }
  after_destroy_commit { destroy_to_all }

  scope :with_participants, -> { includes(:participants) }

  private

  def create_creator_participant
    Participant.create!(name: creator.username,
                        number: creator.number,
                        user_id: creator.id,
                        game_id: self.id)
  end

  def broadcast_to_all
    broadcast_append_to 'games',
                        partial: 'games/game',
                        locals: { game: self }
  end

  def update_to_all
    broadcast_update_to 'games',
                        partial: 'games/game',
                        locals: { game: self }
  end

  def destroy_to_all
    broadcast_remove_to 'games'
  end

end
