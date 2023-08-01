class AddGamesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :games, :integer, default: 0
  end
end
