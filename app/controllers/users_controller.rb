class UsersController < ApplicationController
	def index
		User.all
	end

	def user_posts
		@posts = User.find(params[:id]).posts.page(params[:page]).per(20)
	end

	def show
		@posts = User.friendly.find(params[:id]).posts.page(params[:page]).per(20)
	end

 	def notifications
   	@notifications=current_user.notifications.order('created_at DESC')
   	if @notifications.present?
    		@notifications.each {|n| n.update_attribute('seen',true)}
     		render :layout=>false and return
   	else
      	render :inline=>"<p style='background-color:#75A3FF;width:250px;'>No More Notifications To Show</p>",:layout=>false and return
   	end	
  end
end
