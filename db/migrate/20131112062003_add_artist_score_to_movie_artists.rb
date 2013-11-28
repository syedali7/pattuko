class AddArtistScoreToMovieArtists < ActiveRecord::Migration
  def change
    add_column :movie_artists, :artist_score, :integer
  end
end
