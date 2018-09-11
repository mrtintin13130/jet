class CreateAircrafts < ActiveRecord::Migration[5.2]
  def change
    create_table :aircrafts do |t|
      t.string :Tail
      t.string :Category
      t.string :Type
      t.integer :Maxpax
      t.string :Actual_position
      t.string :price
      t.string :company
      t.string :origin
      t.string :YOM
      t.string :YOR

      t.timestamps
    end
  end
end
