class ShopController < ApplicationController
  def index
  	#@styles = Style.all
  	@styles = Style.page(params[:page]).per(20)

  end

  def show
  	@style = Style.find(params[:id])
  end

  def style_clap
  	style_id = params[:style_id]
  	style = Style.find(style_id)
  	style.claps.create(:user_id => current_user.id)

  	#score
  	clapped_score = Score.create(:user_id => current_user.id,
  	 :score => 3, :action => "clapped for the style id is #{style_id}")
  	clapped_total_score = clapped_score.score
	  current_user.score += clapped_total_score
  	current_user.save

  	redirect_to :back
  end

  def style_update
    movie_id = params[:style_movie_id]
    artist_id = params[:style_artist_id]
    style_id = params[:style_id]
    Style.update_all({:movie_id => movie_id, :artist_id => artist_id}, {:id => style_id})
    redirect_to shop_index_path
  end

  def style_update_render
    @style_id = params[:id]
    #render :layout => false
  end
  
end
