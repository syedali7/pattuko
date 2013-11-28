class AddVerifiedToFeed < ActiveRecord::Migration
  def change
  	add_column :feeds, :verified, :boolean
  end
end

