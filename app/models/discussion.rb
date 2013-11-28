class Discussion < ActiveRecord::Base
	attr_accessible :title,:discription,:created_user
	validates_presence_of :title
	has_many :messages
	has_many :discussion_taggings,:as=>:tagable
	has_one :discussion_video_image
	has_one :image,:through=>:discussion_video_image
	belongs_to :user,:foreign_key=>:created_user
end
