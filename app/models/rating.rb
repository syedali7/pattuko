class Rating < ActiveRecord::Base
	attr_accessible :user_id, :rating, :cuid, :movie_id 
    belongs_to :movie
   
end
