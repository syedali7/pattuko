class AddImageUrlsToNewsUrls < ActiveRecord::Migration
  def change
    add_column :news_urls, :image_url, :string
  end
end
