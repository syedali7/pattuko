class AddCoverImageIdToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :cover_image_id, :integer
  end
end
