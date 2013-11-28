class AddYearToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :year, :string
  end
end
