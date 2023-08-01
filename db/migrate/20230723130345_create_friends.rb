class CreateFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :friends do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friendOf, null: false, foreign_key: { to_table: :users }
      t.string :username
      t.string :number
      t.boolean :request

      t.timestamps
    end
  end
end
