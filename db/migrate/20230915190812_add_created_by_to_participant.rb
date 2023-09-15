class AddCreatedByToParticipant < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :created_by, :integer, default: 0
  end
end
