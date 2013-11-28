class AddValueToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :value, :integer
  end
end
