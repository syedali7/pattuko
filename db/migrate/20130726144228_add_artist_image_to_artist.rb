class AddArtistImageToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :artist_image, :string
  end
end
