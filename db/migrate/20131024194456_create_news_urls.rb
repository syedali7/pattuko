class CreateNewsUrls < ActiveRecord::Migration
  def change
    create_table :news_urls do |t|
      t.string :news_url
      t.string :source_name

      t.timestamps
    end
  end
end
