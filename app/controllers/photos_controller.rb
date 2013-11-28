class PhotosController < ApplicationController

  	def index
  		options = {:page => (params[:page]||1), :per_page=> (params[:per_page] || 20)}
    	@artists = Artist.tire.search(options) do
	      	query {all}
	      	#sort { by :id => 'desc' }
	      	sort do
	      		#  by :id => 'desc'
	        	by :thumb_artist_image_present => 'desc', :id => 'desc'
	      	end
    	end
  	end

  	def artists
  		artist = Artist.friendly.find(params[:id])
      image_ids = Photo.where(:artist_id => artist.id, :deleted => false).collect(&:image_id)
      @images = []
      image_ids.each do |i|
        @images << Image.where(:id => i).first
      end
=begin
@images = []
      images = []
      unless artist.nil?
    		posts = Post.where(:posting_id => artist.id, :posting_type => "Artist")
    		posts.each do |p|
    			if p.postable_type == "News"
    				@images = @images + Image.where(:id => News.find(p.postable_id).image_id)
    			elsif p.postable_type == "Album"
    				images = AlbumImage.where(:album_id => p.postable_id).collect(&:image_id)
    				images.each do |i|
    					@images = @images + Image.where(:id => i)
    				end
    			elsif p.postable_type == "Image"
    				@images = @images + Image.where(:id => p.postable_id)
    			end
    		end
      end
=end

	end

	def movies
		movie = Movie.find_by_name(params[:q])
    @images = []
    images = []
    unless movie.nil?
  		posts = Post.where(:posting_id => movie.id, :posting_type => "Movie")
  		posts.each do |p|
  			if p.postable_type == "News"
  				@images = @images + Image.where(:id => News.find(p.postable_id).image_id)
  			elsif p.postable_type == "Album"
  				images = AlbumImage.where(:album_id => p.postable_id).collect(&:image_id)
  				images.each do |i|
  					@images = @images + Image.where(:id => i)
  				end
  			elsif p.postable_type == "Image"
  				@images = @images + Image.where(:id => p.postable_id)
  			end
  		end
    end
	end

end
