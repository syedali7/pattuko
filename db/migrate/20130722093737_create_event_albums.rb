class CreateEventAlbums < ActiveRecord::Migration
  def change
    create_table :event_albums do |t|
      t.integer :event_id
      t.integer :album_id

      t.timestamps
    end
  end
end
