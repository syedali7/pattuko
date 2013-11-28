ActiveAdmin.register Review do
	 menu :if => proc{ current_admin_user.role == 'admin' }
	index do 
	    column :movie do |review|
	    	name = review.movie.name
	    	link_to name, admin_movie_path(review.movie)
	    end
	  	column :rating
	  	column :analysis
	  	column :punchline
		default_actions
	end

	form do |f|
	  	f.inputs 'create review' do 
	  		telugu_movies = Movie.where(:wood_id => 1)
	  		f.input :movie_id , :label => 'Movie Name', :as => :select,
	  			:collection => telugu_movies.where( "year > ?" ,2012).all.map{|u| [u.name, u.id]}
	  		f.input :website_id , :label => 'Website', :as => :select,
	  			:collection => Website.all.map{|u| [u.name, u.id]}
	  		f.input :website_url
	  		f.input :rating
	  		f.input :analysis
	  		f.input :punchline
	    end
	    f.buttons
	end

	
	collection_action :get_review_details, :method => :post do
		website_id = params[:website_id]
      	movie_id = params[:movie_id]
      	movie = Movie.find(movie_id)
      	website = Website.find(website_id)
      	unless Review.where(:movie_id =>movie_id, :website_id => website_id).empty?
		    respond_to do|format|
		        format.js {render :js=>"alert('#{movie.name} has already have review of #{website.name}');"}
		    end
		else
			redirect_to :back
		end
	end
end
