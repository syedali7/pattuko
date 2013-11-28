class ActivitiesController < ApplicationController

=begin
def index
  	unless current_user.nil?
  		@posts = UserActivity.where(:user_id => current_user.id).uniq.page(params[:page]).per(8)
  	else
  		logger.debug(session[:cuid])
  		@posts = UserActivity.where(:cuid => session[:cuid]).uniq.page(params[:page]).per(8)
  	end
  end
=end

  def show
  end
  
  
  def feedback
    not_satisfied = params[:not_satisfied] == 'on' ? 'not satisfied' : nil
    ok = params[:ok] == 'on' ? 'ok' : nil
    good = params[:good] == 'on' ? 'good' : nil
    improve = params[:improve] == 'on' ? 'improve' : nil
    feedback = "#{not_satisfied} | #{ok} | #{good} | #{improve} "
    if current_user
    	Feedback.create(:user_id => current_user.id, :feedback => feedback)
    else
    	Feedback.create(:cuid => session[:cuid] , :feedback => feedback )
    end

    redirect_to root_path

  end

end
