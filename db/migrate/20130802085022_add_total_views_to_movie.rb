class AddTotalViewsToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :total_views, :integer,:default => 1
  end
end
