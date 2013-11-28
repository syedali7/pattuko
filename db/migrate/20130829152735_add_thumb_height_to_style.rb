class AddThumbHeightToStyle < ActiveRecord::Migration
  def change
    add_column :styles, :thumb_height, :integer
  end
end
