class AddWinnerToGame < ActiveRecord::Migration[7.0]
  def change
    add_reference :games, :winner, foreign_key: { to_table: :participants }
  end
end
