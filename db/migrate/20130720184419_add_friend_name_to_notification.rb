class AddFriendNameToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :friend_name, :string
  end
end
