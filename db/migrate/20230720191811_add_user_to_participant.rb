class AddUserToParticipant < ActiveRecord::Migration[7.0]
  def change
    add_reference :participants, :user
  end
end
