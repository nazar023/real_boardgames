class Notification < ApplicationRecord
  include Noticed::Model
  include ActionView::RecordIdentifier

  belongs_to :recipient, polymorphic: true

  after_create_commit { broadcast_new_notifications }
  after_destroy_commit { broadcast_delete_notifications }

  private

  def broadcast_new_notifications
    broadcast_append_to "#{dom_id(recipient)}_notifications",
                        partial: 'notifications/notification_classifying',
                        locals: { notification: self }
    broadcast_update_to "#{dom_id(recipient)}_notifications",
                        target: 'notification_counter',
                        html: self.recipient.notifications.count

    broadcast_remove_to "game_#{params[:message].game_id}",
                        target: "user_#{recipient.id}"

  end

  def broadcast_delete_notifications
    broadcast_remove_to "#{dom_id(recipient)}_notifications"
    broadcast_update_to "#{dom_id(recipient)}_notifications",
                    target: 'notification_counter',
                    html: self.recipient.notifications.count
  end
end
