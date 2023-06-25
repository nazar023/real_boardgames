class RemoveForeignKey < ActiveRecord::Migration[7.0]
  def change
    # remove the old foreign_key
    remove_foreign_key :participants, :games
  end
end
