class DiscussionVideoImage < ActiveRecord::Base
	belongs_to :discussion
	belongs_to :message
	belongs_to :image
	belongs_to :video
end
