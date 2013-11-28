class AddPollinTypeToPoll < ActiveRecord::Migration
  def change
  	add_reference :polls, :polling, polymorphic: true, index: true
  end
end
