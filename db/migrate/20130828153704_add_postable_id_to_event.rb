class AddPostableIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :postable_id, :integer
  end
end
