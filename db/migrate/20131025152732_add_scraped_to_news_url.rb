class AddScrapedToNewsUrl < ActiveRecord::Migration
  def change
    add_column :news_urls, :scraped, :integer
  end
end
