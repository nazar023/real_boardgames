# frozen_string_literal: true

class Participant < ApplicationRecord # :nodoc:
  validates :name, :number, presence: true

  belongs_to :user, optional: true
  belongs_to :game

  has_one_attached :avatar
end
