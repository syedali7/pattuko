class CreateRelatedPosts < ActiveRecord::Migration
  def change
    create_table :related_posts do |t|
      t.integer :post_id
      t.integer :related_post_id

      t.timestamps
    end
    add_index :related_posts, [ :post_id ]
  end
end
