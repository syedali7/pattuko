class CreateMovieArtists < ActiveRecord::Migration
  def change
    create_table :movie_artists do |t|
      t.integer :movie_id
      t.integer :artist_id
      t.integer :artist_type_id

      t.timestamps
    end
  end
end
