class ChangeDataScrapedForScraped < ActiveRecord::Migration
  def change
  	remove_column :news_urls, :scraped
  	add_column :news_urls, :scraped, :boolean ,:default => false
  end
end
