class AddWoodIdToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :wood_id, :integer
  end
end
