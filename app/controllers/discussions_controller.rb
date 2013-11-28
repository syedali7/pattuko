class DiscussionsController < ApplicationController

  before_filter :current_user

  def index
    @discussions=Discussion.all
    @selected_disc=@discussions.first
  end

  def show
    @selected_disc=Discussion.find(params[:id])
    render :partial=>'show.html.erb'
  end

  def movie_artist
        @selected_disc=Discussion.find(params[:id])
     if params[:tagable_type]=='Movie'
        @discussions=Movie.find(params[:tagable_id]).discussions
     elsif params[:tagable_type]=='Artist'
        @discussions=Artist.find(params[:tagable_id]).discussions   
     end
     render 'discussions/index'
  end

  def create

      @dis=Discussion.create(:title=>" title ......",:created_user=>params[:user_id],:discription=>params[:discription])   

      if params[:movies].present?
        params[:movies].split(',').uniq.each do|m|
          DiscussionTagging.create(:discussion_id => @dis.id,:tagable_id=>m,:tagable_type=>'Movie')         
        end
      end

      if params[:artists].present?
        params[:artists].split(',').uniq.each do|a|
          DiscussionTagging.create(:discussion_id => @dis.id,:tagable_id=>a,:tagable_type=>'Artist')         
        end
      end

      if params[:image_id].present?
        @dis.image=Image.find(params[:image_id])
      end
      
      @dis.save!
      render :text=>"successfully created....."
          #format.any(:js,:html) { render :js=>"$('#err_msg').css({'background-color':'red'}).text('successfully created').show().fadeOut(3000);" }
  end
  
  def discussion_messages
    @discussion=Discussion.find(params[:id])
    render :layout=>false
  end

  def message_create
     @mess=Message.create(:discussion_id=>params[:id],:content=>params[:content],:user_id=>3)
     #@mess=Message.first
     @mess.image=Image.new
     @mess.image.image=params[:image]
     @mess.save
      respond_to do |format|
        unless @mess.errors.present?
           format.any(:html,:js) { render :js=>"<p style='background-color:#CC99FF;'>#{ @mess.content }</p>" }       
        end
      end 
  end

  def select

    a=Movie.where('name like ?',"%#{params[:query]}%").select("id,name,'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif' as avatar,'Movie' as type").to_a
    b=Artist.where('name like ?',"%#{params[:query]}%").select("id,name,'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif' as avatar,'Artist' as type").to_a
    
    c=a.concat(b)

    render :json => c.to_json(:only => [:id, :name, :avatar, :type])

  end

end
