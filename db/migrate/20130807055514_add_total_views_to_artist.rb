class AddTotalViewsToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :total_views, :integer
  end
end
