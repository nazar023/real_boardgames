class CreateGameInvite < ActiveRecord::Migration[7.0]
  def change
    create_table :game_invites do |t|
      t.belongs_to :game, null: false, foreign_key: true
      t.belongs_to :whoSent, null: false, foreign_key: { to_table: :users }
      t.belongs_to :whoGet, null: false, foreign_key: { to_table: :users }
      t.string :desc, optional: true

      t.timestamps
    end
  end
end
