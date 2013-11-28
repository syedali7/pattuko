class Feedback < ActiveRecord::Base
	attr_accessible :user_id, :cuid, :feedback
end
