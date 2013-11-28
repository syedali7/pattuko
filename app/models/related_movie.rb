class RelatedMovie < ActiveRecord::Base
   attr_accessible :movie_id, :related_movie_id, :weight, :reason
   belongs_to :movie
   default_scope order('weight DESC')
end
