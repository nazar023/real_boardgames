# frozen_string_literal: true

class Friend < ApplicationRecord # :nodoc:
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :whoSent, class_name: 'User', foreign_key: 'whoSent_id'
end
