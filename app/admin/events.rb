ActiveAdmin.register Event do
   menu :if => proc{ current_admin_user.role == 'admin' }

   #action_item :false
   index do 
	  	column :name
	  	column :event_type_name do |event|
	  		if event.eventable_id.present?
	            event_type_name = event.eventable_type == "Movie" ? Movie.find(event.eventable_id).name : Artist.find(event.eventable_id).name
	            event_type_name
	        end
        end
	  	column :eventable_id
	  	column :delete do |event|
	  		#link_to "delete", :action => :create_event_form
	  		link_to "delete",event_delete_admin_event_path(:id => event.id)
	  	end
	  	#default_actions
	end

	action_item :only => [:index, :show ] do
	    link_to "Add a new Event", :action => :create_event_form
	end

	collection_action :create_event_form   do
  	end

	

	collection_action :create_event, :method => :post do
		unless params[:movie_id].nil?
			eventable_type = "Movie"
			eventable_id = params[:movie_id]
		else params[:artist_id].nil?
			eventable_type = "Artist"
			eventable_id = params[:artist_id]
		end

		if params[:movie_id].empty? && params[:artist_id].empty?
			Event.create(:name => params[:name], :eventable_id => eventable_id)
		else
			Event.create(:name => params[:name], :eventable_type => eventable_type, :eventable_id => eventable_id)
		end

		redirect_to :back
	end

	member_action :event_delete, :method => :get do
		event = Event.find(params[:id])
		if event.total_posts == 0
			event.delete
			redirect_to :back
		else
			total_posts = event.total_posts
			render :js=>"alert('This Event has #{total_posts} posts');" and return
		end
	end


end
	