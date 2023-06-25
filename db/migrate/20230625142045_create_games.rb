class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name
      t.text :desc
      t.integer :members

      t.timestamps
    end
  end
end
