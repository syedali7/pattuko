class Watch < ActiveRecord::Base
  attr_accessible :cuid, :user_id, :views
  belongs_to :watchable,:polymorphic => true ,:counter_cache => :total_views 	
end
