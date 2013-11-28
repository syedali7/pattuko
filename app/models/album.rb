class Album < ActiveRecord::Base
  attr_accessible :album_name, :cover_image_id, :post_id
  has_many :posts, as: :postable
  has_many :images, :through => :album_images
  has_many :album_images
  belongs_to :post, touch: true
end
