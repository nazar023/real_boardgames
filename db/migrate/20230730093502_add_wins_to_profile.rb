class AddWinsToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :wins, :integer, default: 0
  end
end
