class UserActivity < ActiveRecord::Base
  attr_accessible :user_id,:post_id, :weight, :deleted, :post_image, :post_title,
   					:post_type, :post_created_on, :created_on, :image_thumb_height, :cuid
  default_scope order('created_at DESC')
end
