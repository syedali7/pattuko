class CreateSitemaps < ActiveRecord::Migration
  def change
    create_table :sitemaps do |t|
      t.string :url
      t.string :title
      t.text :description
      t.string :keywords

      t.timestamps
    end
  end
end
