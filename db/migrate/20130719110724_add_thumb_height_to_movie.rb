class AddThumbHeightToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :thumb_height, :integer
  end
end
