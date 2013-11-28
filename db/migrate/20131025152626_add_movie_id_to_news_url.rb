class AddMovieIdToNewsUrl < ActiveRecord::Migration
  def change
    add_column :news_urls, :movie_id, :integer
  end
end
