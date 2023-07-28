class CreateFriendRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :friend_requests do |t|
      t.string :username
      t.string :number
      t.integer :friend_id
      t.integer :profile_id

      t.timestamps
    end
  end
end
