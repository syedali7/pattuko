class CreateDiscussionTaggings < ActiveRecord::Migration
  def self.up
    create_table :discussion_taggings do |t|
    	t.column :discussion_id,:integer
    	t.column :tagable_id,:integer
    	t.column :tagable_type,:string
    	t.timestamps
    end
    remove_column :discussions,:on_id
    remove_column :discussions,:on_type
  end

  def self.down
  	drop_table :discussion_taggings
  	add_column :discussions,:on_id,:integer
    add_column :discussions,:on_type,:string
  end
end
