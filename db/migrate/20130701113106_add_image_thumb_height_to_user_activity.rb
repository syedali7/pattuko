class AddImageThumbHeightToUserActivity < ActiveRecord::Migration
  def change
    add_column :user_activities, :image_thumb_height, :integer
  end
end
