class AddPostableTypeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :postable_type, :string
  end
end
