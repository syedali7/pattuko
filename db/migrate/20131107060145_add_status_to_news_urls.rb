class AddStatusToNewsUrls < ActiveRecord::Migration
  def change
    add_column :news_urls, :status, :string
  end
end
