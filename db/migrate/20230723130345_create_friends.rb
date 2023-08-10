class CreateFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :friends do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :whoSent, null: false, foreign_key: { to_table: :users }
      t.boolean :request

      t.timestamps
    end
  end
end
