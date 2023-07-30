class CreateFriendRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :friend_requests do |t|
      t.string :username
      t.string :number
      t.belongs_to :friend, foreign_key: { to_table: :users }
      t.belongs_to :profile, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
