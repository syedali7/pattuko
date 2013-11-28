class AddAlbumUrlToNewsUrls < ActiveRecord::Migration
  def change
    add_column :news_urls, :album_urls, :string
  end
end
