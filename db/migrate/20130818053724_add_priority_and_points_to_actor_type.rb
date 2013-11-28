class AddPriorityAndPointsToActorType < ActiveRecord::Migration
  def change
  	add_column :artist_types, :priority, :integer
  	add_column :artist_types, :points, :integer
  end
end
