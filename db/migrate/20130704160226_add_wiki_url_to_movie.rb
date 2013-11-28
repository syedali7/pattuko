class AddWikiUrlToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :wiki_url, :string
  end
end
