class Notification < ActiveRecord::Base
  attr_accessible :friend_id, :notification, :user_id, :friend_name
end
