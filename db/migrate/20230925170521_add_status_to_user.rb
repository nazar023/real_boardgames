class AddStatusToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :status, :integer, default: 0
    add_column :users, :last_time_online_at, :timestamp, default: Time.now
  end
end
