class Like < ActiveRecord::Base
	attr_accessible :user_id,:likeable_id,:likeable_type,:value
	belongs_to :likeable, :polymorphic => true
end
