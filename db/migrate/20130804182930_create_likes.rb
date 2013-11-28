class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.belongs_to :likeable, polymorphic: true
      t.timestamps
    end
    add_index :likes, [ :likeable_id , :likeable_type ]
  end
end
