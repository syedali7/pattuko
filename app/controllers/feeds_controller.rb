class FeedsController < ApplicationController
  def index
  	begin
      if current_user
      	@posts = Feed.where(:user_id => current_user.id).uniq.page(params[:page]).per(20)
      else
      	redirect_to root_path
      end
    rescue ActiveRecord::RecordNotFound
      return
    end
  end
end
