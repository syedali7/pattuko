class ChangeDateFormatInMovies < ActiveRecord::Migration
  def change
  	remove_column :movies, :realesed_at
  	add_column :movies, :realesed_at, :date
  end
end
