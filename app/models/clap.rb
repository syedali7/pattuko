class Clap < ActiveRecord::Base
	attr_accessible :user_id

	belongs_to :post, :foreign_key => 'clap_id', :counter_cache => true, touch: true
end
