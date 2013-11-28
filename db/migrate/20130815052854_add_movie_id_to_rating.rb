class AddMovieIdToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :movie_id, :integer
  end
end
