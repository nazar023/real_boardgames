class AddWinnerToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :winner_id, :integer
  end
end
