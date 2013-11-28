ActiveAdmin.register User do

	filter :username
	
	action_item do
		link_to "Admin User Posts", :action => :admin_user_posts
	end

  	index do 
	  	table_for User.order("created_at desc").page(params[:page]).per(20) do 
	        column :id do |user|
	            link_to user.id, admin_user_path(:id => user.id)
	        end
	        column :email do |user|
	            link_to user.email, admin_user_path(:id => user.id)
	        end
	        column :username do |user|
	            link_to user.username, admin_user_path(:id => user.id)
	        end
	        column :post_count do |user|
		  	 	user.posts.count
		  	end
	    end
    end

    collection_action :admin_user_posts do
    	#@dates = (Date. .. Date.parse('2009-01-31')).map{|d| d.to_s}
    	#@posts = Post.where(:created_at => Date.today)
    	@posts_d = Post.where(:user_id => 11, :created_at => Date.today).all
    	@posts = Post.all
    	#@posts_d = Post.where(:user_id => 11)
=begin
email = []
    	User.all.each do |u|
    		emails = emails + AdminUser.where(:email => u.email)
    	end
    	@admin_posts = []
    	emails.each do |e|
 			@admin_posts << Post.where(:user_id => e.id)
 		end
=end

  	end

  menu :if => proc{ current_admin_user.role == 'admin' }
end

