class Review < ActiveRecord::Base
  attr_accessible :analysis, :punchline, :rating, :movie_image, :movie_id, :website_id, :user_id,:cuid,:website_url
  has_many :likes, as: :likeable
  validates_uniqueness_of :analysis, :scope => :website_id
  belongs_to :movie
end
