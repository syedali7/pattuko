class AddTrustedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :trusted, :boolean
  end
end
