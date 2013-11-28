class AddRealesedAtToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :realesed_at, :string
  end
end
