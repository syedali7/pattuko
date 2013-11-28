class AddWeightToRelatedPost < ActiveRecord::Migration
  def change
    add_column :related_posts, :weight, :integer, :default => 0
  end
end
