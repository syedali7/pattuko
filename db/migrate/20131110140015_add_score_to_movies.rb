class AddScoreToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :score, :integer
  end
end
