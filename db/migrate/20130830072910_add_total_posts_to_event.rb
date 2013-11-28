class AddTotalPostsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :total_posts, :integer, :default => 0	
  end
end
