class AddPostIdToError < ActiveRecord::Migration
  def change
    add_column :errors, :post_id, :integer
  end
end
