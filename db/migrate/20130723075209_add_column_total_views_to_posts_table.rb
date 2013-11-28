class AddColumnTotalViewsToPostsTable < ActiveRecord::Migration
  def self.up
  	add_column :posts,:total_views,:integer,:default => 0
  end
  def self.down
  	remove_column :posts,:total_views
  end
end
