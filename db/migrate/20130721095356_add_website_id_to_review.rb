class AddWebsiteIdToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :website_id, :integer
  end
end
