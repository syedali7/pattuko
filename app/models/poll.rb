class Poll < ActiveRecord::Base
	attr_accessible :user_id , :poll_name
	belongs_to :polling, :polymorphic => true, :counter_cache => true, touch: true
	has_many :questions
end
