class VideosController < ApplicationController
	def index
	end

	def artists
  		artist = Artist.find_by_name(params[:q])
  		posts = Post.where(:posting_id => artist.id, :posting_type => "Artist", :postable_type => "Video")
  		@videos = []
  		posts.each do |p|
  			@videos << Video.where(:id => p.postable_type)
  		end
	end

	def movies
		movie = Movie.find_by_name(params[:q])
  		posts = Post.where(:posting_id => movie.id, :posting_type => "Movie", :postable_type => "Video")
  		@videos = []
  		posts.each do |p|
  			@videos << Video.where(:id => p.postable_type)
  		end
	end
end
