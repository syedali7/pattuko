class CreateAlbumImages < ActiveRecord::Migration
  def change
    create_table :album_images do |t|
      t.integer :image_id
      t.integer :album_id

      t.timestamps
    end
  end
end
