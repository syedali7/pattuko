class Wood < ActiveRecord::Base
   attr_accessible :wood
   has_many :movies
   has_many :fans, as: :fan
end
