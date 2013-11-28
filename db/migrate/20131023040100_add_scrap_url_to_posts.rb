class AddScrapUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :scrap_url, :string
  end
end
