class CreateTheatres < ActiveRecord::Migration
  def change
    create_table :theatres do |t|
      t.string :theatre
      t.string :city
      t.string :district
      t.string :location
      t.integer :seats
      t.string :rating

      t.timestamps
    end
  end
end
