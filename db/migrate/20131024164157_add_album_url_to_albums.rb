class AddAlbumUrlToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :album_url, :string
  end
end
