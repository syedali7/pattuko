class ApplicationController < ActionController::Base
		
	helper :all
	protect_from_forgery

	before_filter :set_fans_to_the_user

	#before_filter :redirect_to_feed

	before_filter :redirect_to_page

	before_filter :last_log_in

	include ActionController::Caching

	def redirect_to_page
		unless session[:return_to].nil?
			redirect_to(session[:return_to])
	  		session[:return_to] = nil
	  	end
	end

	def redirect_to_feed
		if request.fullpath == "/" && !current_user.nil? 
	      	feed_count = Feed.where(:user_id => current_user.id).count
	    	fan_count = Fan.where(:user_id => current_user.id).uniq.count
	    	if (feed_count >= 20 || fan_count >= 5) 
		        redirect_to feeds_path
	      	end
		end
	end

	def redirect_to_404
		if id.is_a? Integer
	        unless Post.find(params[:id]).slug.present?
	          render :status => 404
	        end
      	end
	end

	def last_log_in
		if current_user
			if current_user.last_sign_in_at > Time.now - 1.day
				current_user.last_log_in_at = Time.now
				current_user.save
			end
		end 
	end

	def render_404(exception)
	    @not_found_path = exception.message
	    respond_to do |format|
	      format.html { render :template => 'errors/error_404', :layout => 'layouts/application', :status => 404 }
	      format.all { render :nothing => true, :status => 404 }
	    end	
	    redirect_to root_url
	end

	def set_fans_to_the_user
		if session[:cuid].nil?
			session[:cuid] = rand(9999999999).to_s.center(10, rand(9).to_s).to_i
		end

		if current_user && session[:fans_set] != true
			logger.debug("Session fanset is true")
			Fan.update_all({:user_id => current_user.id}, {:cuid => session[:cuid]})
			wood_ids  = Fan.where(:user_id => current_user.id, :fan_type => 'Wood').map(&:fan_id).uniq
			movie_ids = []
			wood_ids.each do |w|
				 movie_ids = movie_ids + Wood.find(w).movies.map(&:id)
			end
			posts = Post.where(:posting_type => "Movie", :posting_id => movie_ids)
			posts.each do |p|
				ua = UserActivity.where(:post_id => p.id, :user_id => current_user.id).first
				if ua.nil?
					if (p.postable_type == "News")
						image_id = News.find(p.postable_id).image_id
						image_url = Image.find(image_id).image.url(:thumb).to_s
						thumb_height = Image.find(image_id).thumb_height
					elsif (p.postable_type == "Image")
						image_id = Image.find(p.postable_id).id
						image_url = Image.find(image_id).image.url(:thumb).to_s
						thumb_height = Image.find(image_id).thumb_height
					elsif (p.postable_type == "Album")
						image_id = Album.find(p.postable_id).images.first.id
						image_url = Image.find(image_id).image.url(:thumb).to_s
						thumb_height = Image.find(image_id).thumb_height
					elsif (p.postable_type == "Video")
						video_id = Video.find(p.postable_id).id
						image_url = "http://d154rvuufl6jl1.cloudfront.net/video_images/#{video_id}.jpg"
						thumb_height = 360
					end
					cuid = session[:cuid]

					user_activity = UserActivity.create(:user_id => current_user.id, :post_id => p.id, :post_image => image_url, :post_title => p.title, 
			              :post_type => p.postable_type, :post_created_on => p.created_at , :image_thumb_height => thumb_height,
			              :cuid => cuid)
				end	
			end
			session[:fans_set] = true
		end
	end
end