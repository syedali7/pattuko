class AddMovieImageToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :movie_image, :string
  end
end
