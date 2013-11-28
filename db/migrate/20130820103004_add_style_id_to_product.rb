class AddStyleIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :style_id, :integer
  end
end
