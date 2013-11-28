class AddEditedToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :edited, :boolean
  end
end
