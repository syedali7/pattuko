class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :weight
      t.boolean :deleted
      t.string  :post_image
      t.string  :post_title
      t.string  :post_type
      t.date    :post_created_on
      t.date    :created_on
      t.timestamps
    end
  end
end
