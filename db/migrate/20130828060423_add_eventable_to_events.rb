class AddEventableToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :eventable, polymorphic: true, index: true
  end
end
