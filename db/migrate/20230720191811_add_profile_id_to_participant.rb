class AddProfileIdToParticipant < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :profile, :integer
    add_index :participants, :profile
  end
end
