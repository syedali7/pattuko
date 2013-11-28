module PostsHelper

	def show_page_title(post)
		return  post.title  
	end

	def show_page_description(post)
		if post.posting_type == "Artist"
			artist = Artist.find(post.posting_id)
			return artist.name + " " + post.title
		elsif post.posting_type == "Movie"
			movie = Movie.find(post.posting_id)
			return movie.name + " " + post.title
		elsif post.posting_type == "Event"
			event = Event.find(post.posting_id)
			if event.eventable_type == "Artist"
				artist = Artist.find(event.eventable_id)
				return artist.name + " " + post.title
			elsif event.eventable_type == "Movie"
				movie = Movie.find(event.eventable_id)
				return movie.name + " " + post.title
			end
		end
	end

	def posting_fan(post)
		if post.posting_type == "Artist"
			artist = Artist.find(post.posting_id)
			if artist.fans.collect(&:user_id).include?(current_user.id) 
				return true
			else
				return false
			end
		elsif post.posting_type == "Movie"
			movie = Movie.find(post.posting_id)
			if movie.fans.collect(&:user_id).include?(current_user.id)
				return true
			else
				return false
			end 
		end
	end

	def posting_type(post)
		if post.posting_type == "Movie"
			movie = Movie.find(post.posting_id)
			return movie
		elsif post.posting_type == "Artist"
			artist = Artist.find(post.posting_id)
			return artist
		elsif post.posting_type == "Event"
			event = Event.find(post.posting_id)
			if event.eventable_type == "Artist"
				artist = Artist.find(event.eventable_id)
				return artist
			elsif event.eventable_type == "Movie"
				movie = Movie.find(event.eventable_id)
				return movie
			elsif event.eventable_type.nil?
				return event
			end
		end
	end

	def cache_key_for_products
	    count          = Post.count
	    max_updated_at = Post.maximum(:updated_at).try(:utc).try(:to_s, :number)
	    "posts/all-#{count}-#{max_updated_at}"
	end
end
