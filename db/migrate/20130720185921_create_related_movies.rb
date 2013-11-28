class CreateRelatedMovies < ActiveRecord::Migration
   def change
    create_table :related_movies do |t|
      t.integer :movie_id
      t.integer :related_movie_id
      t.integer :weight
      t.timestamps
    end
    add_index :related_movies, [ :movie_id ]
  end
end
