class AddMediumHeightToImage < ActiveRecord::Migration
	def self.up
    	add_column :images, :medium_height, :integer

    	#Image.all.each do |image|
      	#	begin
		#	    image.medium_height = Magick::Image::read((image.image.url(:medium))).first.rows
		#	    image.save
	  	#	rescue
	  	#	end
		#end
  	end
end



