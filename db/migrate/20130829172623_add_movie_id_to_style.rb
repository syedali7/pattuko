class AddMovieIdToStyle < ActiveRecord::Migration
  def change
    add_column :styles, :movie_id, :integer
  end
end
