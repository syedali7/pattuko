class AddCuidToUserActivity < ActiveRecord::Migration
  def change
    add_column :user_activities, :cuid, :string
  end
end
