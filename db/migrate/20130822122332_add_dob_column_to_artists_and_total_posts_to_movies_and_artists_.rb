class AddDobColumnToArtistsAndTotalPostsToMoviesAndArtists < ActiveRecord::Migration
  def self.up
    add_column :artists,:dob,:date
    add_column :artists,:total_posts,:integer,:default=>0
    add_column :movies,:total_posts,:integer,:default=>0
  end
  def self.down
    remove_column :artists,:dob
    remove_column :movies,:total_posts
    remove_column :artists,:total_posts
  end
end
