class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :image_id
      t.integer :movie_id
      t.integer :artist_id
      t.integer :event_id
      t.boolean :deleted, :default => 0

      t.timestamps
    end
  end
end
