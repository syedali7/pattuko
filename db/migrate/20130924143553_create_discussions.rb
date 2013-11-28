class CreateDiscussions < ActiveRecord::Migration
  def self.up
    create_table :discussions do |t|
      t.string :title
      t.integer :on_id
      t.string :on_type
      t.column :created_user,:integer
      t.timestamps
    end
  end

  def self.down
    drop_table :discussions
  end
end
