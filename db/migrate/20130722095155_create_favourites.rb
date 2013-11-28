class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.integer :user_id
      t.belongs_to :favourable, polymorphic: true
      t.timestamps
    end
    add_index :favourites, [ :favourable_id , :favourable_type ]
  end
end

