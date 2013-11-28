class AddSourceUrlToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :source_url, :string
  end
end
