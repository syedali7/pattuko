class Mention < ActiveRecord::Base
	attr_accessible :post_id
	belongs_to :mentionable, :polymorphic => true, :counter_cache => true, touch: true
end
