class Outlink < ActiveRecord::Base
	attr_accessible :user_id, :cuid, :from_url, :destination_url, :source_type
end
