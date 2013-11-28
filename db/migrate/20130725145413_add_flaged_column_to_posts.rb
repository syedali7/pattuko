class AddFlagedColumnToPosts < ActiveRecord::Migration
  def self.up
  	add_column :posts,:flaged,:boolean
  end
  def self.down
  	remove_column :posts,:flaged
  end
end
