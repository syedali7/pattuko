ActiveAdmin.register Artist do
  menu :if => proc{ current_admin_user.role == 'admin' }
  index do 
  	column "Name" do|a|
      link_to a.name,artist_movies_admin_artist_path(a.id)
    end
  	column :profession
  	column "Duplicate Artists",:id do|artist|
  		link_to "duplicates",duplicate_artists_admin_artist_path(:id=>artist.id)
    end
    column 'Total Posts' do|artist|
      artist.total_posts
    end
  	default_actions
  end
  member_action :duplicate_artists, :method => :get do
     @artist=Artist.find(params[:id])
     len=@artist.name.length
     @duplicate=Artist.where('id != ? and name like ?',@artist.id,"#{@artist.name[0]}%#{@artist.name[len-1]}")     
     render 'duplicates'
  end

  member_action :artist_movies,:method=> :get do 
    if(params[:delete_ma]=="true") 
        @ma=MovieArtist.find(params[:ma])
        if @ma.destroy
         render :text=>"deleted",:layout=>false and return
       else
         render :text=>'not deleted',:layout=>false and return
        end 
    else
        @artist=Artist.includes(:movies).find(params[:id])     
    end
  end

  member_action :new_movie_add,:method=>:get do
    @ma=MovieArtist.create(:movie_id=>params[:movie][:id],:artist_id=>params[:id],:artist_type_id=>params[:artist_type][:id])
    if @ma.errors.present?
      flash[:notice]="cannot add same artist type  again for the same movie :-)"
    end
    redirect_to artist_movies_admin_artist_path(params[:id])
  end

  member_action :duplicate_artist_delete, :method => :post do
     @artist=Artist.find(params[:id])
     @dup_artist=Artist.find(params[:dartist_id])
     @posts=@dup_artist.posts
      if @posts.present?
        @posts.each do |p|
          p.update_attribute(:posting_id,@artist.id)
        end
      end  
     total=@artist.posts.select('posting_id').where(:posting_id=>@artist.id).count
     @dup_artist.destroy
     render :js=>"alert('succefully transfered posts deleting duplicate');$('#act#{@artist.id}').text(#{total});$('#dup#{@dup_artist.id}').html('<p>removed<p>');"
  end  
end
