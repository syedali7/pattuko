class Wish < ActiveRecord::Base
	attr_accessible :wish_id,:wish_type,:user_id,:greeting
	belongs_to :wish, :polymorphic=>true
	validates :user_id,:greeting,:presence=>true
end
