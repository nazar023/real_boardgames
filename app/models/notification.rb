class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create_commit { broadcast_new_notifications }
  after_destroy_commit { broadcast_delete_notifications }

  private

  def broadcast_new_notifications
    broadcast_append_to 'notifications',
                        partial: 'notifications/notification_classifying',
                        locals: { notification: self }
    broadcast_update_to 'notifications',
                        target: 'notification_counter',
                        html: self.recipient.notifications.count
  end

  def broadcast_delete_notifications
    broadcast_remove_to 'notifications'
    broadcast_update_to 'notifications',
                    target: 'notification_counter',
                    html: self.recipient.notifications.count
  end
end
