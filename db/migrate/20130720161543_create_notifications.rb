class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :friend_id
      t.string :notification

      t.timestamps
    end
  end
end
