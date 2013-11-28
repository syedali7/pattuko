class Friend < ActiveRecord::Base
  attr_accessible :user_id, :friend_id
  belongs_to :user
end
