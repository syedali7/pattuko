class AlbumImage < ActiveRecord::Base
  attr_accessible :album_id, :image_id
  belongs_to :album
  belongs_to :image
end
