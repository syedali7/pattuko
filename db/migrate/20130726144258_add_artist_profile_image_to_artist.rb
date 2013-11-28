class AddArtistProfileImageToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :artist_profile_image, :string
  end
end
