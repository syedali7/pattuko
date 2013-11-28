class Fan < ActiveRecord::Base
  attr_accessible :user_id , :wood_id, :cuid
  belongs_to :fan, polymorphic: true
  belongs_to :user
end

