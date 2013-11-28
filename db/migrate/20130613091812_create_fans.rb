class CreateFans < ActiveRecord::Migration
  def change
    create_table :fans do |t|
      t.integer :user_id
      t.belongs_to :fan, polymorphic: true
      t.timestamps
    end
    add_index :fans, [ :fan_id , :fan_type ]
  end
end
