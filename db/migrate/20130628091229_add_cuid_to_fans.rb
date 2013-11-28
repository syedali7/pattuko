class AddCuidToFans < ActiveRecord::Migration
  def change
  	add_column :fans, :cuid, :integer , :limit => 8
  end
end
