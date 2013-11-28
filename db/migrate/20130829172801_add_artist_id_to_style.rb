class AddArtistIdToStyle < ActiveRecord::Migration
  def change
    add_column :styles, :artist_id, :integer
  end
end
