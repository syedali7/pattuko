class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :brand
      t.string :title
      t.integer :mrp
      t.integer :price
      t.text :offer_note
      t.timestamps
    end
  end
end