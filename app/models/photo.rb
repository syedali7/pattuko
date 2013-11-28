class Photo < ActiveRecord::Base
	attr_accessible :image_id, :movie_id, :artist_id, :event_id, :deleted
end
