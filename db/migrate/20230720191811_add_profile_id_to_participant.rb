class AddProfileIdToParticipant < ActiveRecord::Migration[7.0]
  def change
    add_reference :participants, :profile
  end
end
