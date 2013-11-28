class Comment < ActiveRecord::Base
  attr_accessible :user_id , :body
  belongs_to :commentable, :polymorphic => true, :counter_cache => true, touch: true
  belongs_to :user
  has_many :likes, as: :likeable
  default_scope order('created_at DESC')

  def user_name
  	user.username
	end

	def user_image_url
		user.image_url
	end
end
