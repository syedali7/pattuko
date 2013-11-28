class MovieArtist < ActiveRecord::Base
  attr_accessible :artist_id, :artist_type_id, :movie_id ,:artist_score

  belongs_to :movie
  belongs_to :artist
  belongs_to :artist_type
  
  validates_uniqueness_of :artist_type_id,:scope=>[:artist_id,:movie_id]

end
