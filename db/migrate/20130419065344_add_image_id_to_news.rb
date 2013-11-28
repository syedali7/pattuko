class AddImageIdToNews < ActiveRecord::Migration
  def change
    add_column :news, :image_id, :integer
  end
end
