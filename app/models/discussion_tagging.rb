class DiscussionTagging < ActiveRecord::Base
	attr_accessible :discussion_id,:tagable_id,:tagable_type

	belongs_to :discussion
	belongs_to :tagable,:polymorphic=>true
	belongs_to :user,:foreign_key=>:created_user
end
