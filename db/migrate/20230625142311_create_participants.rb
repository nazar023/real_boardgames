class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.references :game, null: false, foreign_key: true
      t.string :name
      t.string :number

      t.timestamps
    end
  end
end
