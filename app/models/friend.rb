# frozen_string_literal: true

class Friend < ApplicationRecord # :nodoc:
  validates :username, :number, :user_id, :whoSent_id, presence: true

  belongs_to :user
  has_one_attached :avatar
end
