# frozen_string_literal: true

class Friend < ApplicationRecord # :nodoc:
  belongs_to :user
  belongs_to :whoSent, class_name: 'User', foreign_key: 'whoSent_id'

  scope :with_users_avatars, -> { includes(user: :avatar_attachment, whoSent: :avatar_attachment) }
  scope :not_request, -> { where(request: false) }
end
