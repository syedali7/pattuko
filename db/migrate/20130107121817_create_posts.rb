class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.belongs_to :postable, polymorphic: true

      t.timestamps
    end
    add_index :posts, [:postable_id, :postable_type]
  end
end
