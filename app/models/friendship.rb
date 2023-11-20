# frozen_string_literal: true

class Friendship < ApplicationRecord # :nodoc:
  belongs_to :receiver, class_name: 'User', inverse_of: :friendships_reqs, foreign_key: 'receiver_id'
  belongs_to :sender, class_name: 'User', inverse_of: :friendships, foreign_key: 'sender_id'

  enum status: %i[pending accepted]

  has_one :notification, as: :subject, dependent: :destroy

  scope :with_users_avatars, -> { includes(receiver: :avatar_attachment, sender: :avatar_attachment) }
  # scope :not_request, -> { where(request: false) }
  after_create_commit { create_notification }

  def accept
    accepted!
    notification.destroy
  end

  def decline
    destroy
    notification.destroy

  end

  private

  def create_notification
    Notification.create(user_id: receiver.id, subject_type: self.class, subject_id: id)
  end
end
