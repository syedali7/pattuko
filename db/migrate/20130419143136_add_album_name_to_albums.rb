class AddAlbumNameToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :album_name, :string
  end
end
