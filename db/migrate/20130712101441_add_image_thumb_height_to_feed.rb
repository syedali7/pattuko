class AddImageThumbHeightToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :image_thumb_height, :integer
  end
end
