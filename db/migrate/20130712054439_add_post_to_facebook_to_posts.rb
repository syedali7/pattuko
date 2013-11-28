class AddPostToFacebookToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :post_to_facebook, :boolean
  end
end
