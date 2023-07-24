# frozen_string_literal: true

class Friend < ApplicationRecord # :nodoc:
  validates :username, :number, presence: true

  belongs_to :profile
end
