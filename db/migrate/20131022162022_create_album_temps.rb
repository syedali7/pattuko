class CreateAlbumTemps < ActiveRecord::Migration
  def change
    create_table :album_temps do |t|
      t.string :posting_type
      t.string :url
      t.boolean :done
      t.date :date
      t.string :mention_movie_id
      t.string :mention_artist_id
      t.integer :user_id

      t.timestamps
    end
  end
end
