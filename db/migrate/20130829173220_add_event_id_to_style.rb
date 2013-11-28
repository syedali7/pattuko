class AddEventIdToStyle < ActiveRecord::Migration
  def change
    add_column :styles, :event_id, :integer
  end
end
