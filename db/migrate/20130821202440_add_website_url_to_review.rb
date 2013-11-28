class AddWebsiteUrlToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :website_url, :string
  end
end
