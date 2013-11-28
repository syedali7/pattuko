class AddDescriptionToError < ActiveRecord::Migration
  def change
    add_column :errors, :description, :text
  end
end
