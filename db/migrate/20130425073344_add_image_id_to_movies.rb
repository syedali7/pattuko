class AddImageIdToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :image_id, :integer
  end
end
