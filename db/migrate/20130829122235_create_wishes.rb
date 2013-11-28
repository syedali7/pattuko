class CreateWishes < ActiveRecord::Migration
  def self.up
    create_table :wishes do |t|
      t.column :wish_id,:integer
      t.column :wish_type,:integer
      t.column :greeting,:string
      t.column :user_id,:integer
      t.timestamps
    end
  end
  def self.down
  	drop_table :wishes
  end
end
