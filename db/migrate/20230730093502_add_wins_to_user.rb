class AddWinsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :wins_count, :integer, default: 0
  end
end
