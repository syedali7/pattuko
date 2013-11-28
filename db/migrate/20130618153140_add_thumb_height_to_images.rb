class AddThumbHeightToImages < ActiveRecord::Migration
  def change
    add_column :images, :thumb_height, :integer
  end
end
