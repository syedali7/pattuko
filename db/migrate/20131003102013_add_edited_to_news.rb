class AddEditedToNews < ActiveRecord::Migration
  def change
    add_column :news, :edited, :boolean
  end
end
