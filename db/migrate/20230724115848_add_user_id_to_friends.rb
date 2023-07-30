class AddUserIdToFriends < ActiveRecord::Migration[7.0]
  def change
    add_reference :friends, :user
  end
end
