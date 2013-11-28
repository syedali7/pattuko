class Feed < ActiveRecord::Base
	attr_accessible :user_id,:post_id, :weight, :deleted, :post_image, :post_title,
   					:post_type, :post_created_on, :created_on, :image_thumb_height,
   					:verified,:priority, :queue, :payload_object
  	default_scope order('post_created_on DESC')
end
