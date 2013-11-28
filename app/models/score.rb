class Score < ActiveRecord::Base
	attr_accessible :user_id, :score, :action
end
