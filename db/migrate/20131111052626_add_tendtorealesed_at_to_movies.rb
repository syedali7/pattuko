class AddTendtorealesedAtToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :tendtorealeased_at, :string
  end
end
