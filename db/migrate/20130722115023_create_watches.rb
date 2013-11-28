class CreateWatches < ActiveRecord::Migration
  def self.up
    create_table :watches do |t|
      t.integer :watchable_id
      t.string :watchable_type
      t.integer :user_id
      t.column :cuid,:bigint
      
      t.timestamps
    end
    add_index :watches, [ :watchable_id , :watchable_type ]
  end
  def self.down
  	drop_table :watches
  end
end
