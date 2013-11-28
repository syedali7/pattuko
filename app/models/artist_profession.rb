class ArtistProfession < ActiveRecord::Base
	attr_accessible :artist_id, :artist_type_id, :profession
	belongs_to :artist
end
