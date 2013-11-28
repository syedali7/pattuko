class AddTrendingColumnPostsTable < ActiveRecord::Migration
  def self.up
    add_column :posts,:trending,:boolean,:default=>false
  end
  def self.down
    remove_column :posts,:trending
  end
end
