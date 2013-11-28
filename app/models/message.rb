class Message < ActiveRecord::Base
	attr_accessible :content,:discussion_id,:user_id
	belongs_to :discussion
	belongs_to :user
	has_one :discussion_video_image
	has_one :image,:through=>:discussion_video_image
	validates_presence_of :content
	#has_many :discussion_video_images
    #has_many :images,:through=>:discussion_video_images
    #accepts_nested_attributes_for :images
    #has_one  :video,:join_table=>'discussion_video_images'
end
