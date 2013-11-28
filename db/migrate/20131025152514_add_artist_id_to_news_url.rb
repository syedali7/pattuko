class AddArtistIdToNewsUrl < ActiveRecord::Migration
  def change
    add_column :news_urls, :artist_id, :integer
  end
end
