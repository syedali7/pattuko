class AlbumTemp < ActiveRecord::Base
	attr_accessible :posting_type, :url, :done, :date, :mention_movie_id, :mention_artist_id, :user_id
end
