class ChangeCoverImageIdToAlbums < ActiveRecord::Migration
  def self.up
    Album.all.each do |a|
  		a.cover_image_id = a.images.first.id
  		a.save
  	end
  end

  def self.down
  end
end
