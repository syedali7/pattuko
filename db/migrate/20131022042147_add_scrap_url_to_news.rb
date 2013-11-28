class AddScrapUrlToNews < ActiveRecord::Migration
  def change
    add_column :news, :scrap_url, :string
  end
end
