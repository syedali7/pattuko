ActiveAdmin.register Movie do
  menu :if => proc{ current_admin_user.role == 'admin' }
  scope :edited

  filter :name

  member_action :quick_edit do
    @movie = Movie.find(params[:id])
  end

  action_item :only => [:index, :show ] do
    link_to "update or create movies", :action => :bulk_edit
  end
  action_item :only => [:index, :show ] do
    link_to "update_movie_artist", :action => :movie_dataentry
  end  

  index do 
    table_for Movie.order("created_at desc").page(params[:page]).per(20) do 
        column :id do |movie|
            link_to movie.id, admin_movie_path(:id => movie.id)
        end
        column :name do |movie|
            link_to movie.name, admin_movie_path(:id => movie.id)
        end
        column :artists do |movie|
          movie.artists.collect{ |a| a.name}.join(",")
        end
        column "Total Posts"do|movie|
          movie.total_posts
        end
        column "Duplicate Movies",:id do|movie|
          link_to "duplicates",duplicate_movies_admin_movie_path(:id=>movie.id)
        end
    end
  end
  
  show do
    panel movie.name do 
      render 'movie_casting'
    end 
  end

  collection_action :bulk_edit   do
    if(defined?params[:non_admin_page])!=nil
      @na_request=params[:non_admin_page]
    else
      @na_request=false 
    end
  end
  collection_action :movie_dataentry   do
    if(defined?params[:non_admin_page])!=nil
      @na_request=params[:non_admin_page]
    else
      @na_request=false 
    end
  end

  collection_action :get_movie_details, :method => :post do
      movie_id = params[:movie_id]
      @movie = Movie.find(movie_id)
      render :layout => false
  end
  collection_action :movie_dataentry do
    @movie = Movie.all.page(params[:page]).per(20)
  end
  collection_action :movie_select, :method => :get do
    movie_id = params[:movie_id]
      @movie = Movie.find(movie_id)
      render :layout => false
  end  
  
  collection_action :search_movie_results, :method => :get do 
     @movies = Movie.where("name like ?","%" + params[:q] + "%").limit(10)
     result = []
     @movies.each do |movie|
      result << { :id => movie.id, :name =>  movie.name}
     end
     respond_to do |format|
      format.html
      format.json { render :json => { :total => @movies.count, :movies => result } }
    end
  end

  collection_action :get_artists, :method => :get do
    @artists = Artist.where("name like ?","%" + params[:q] + "%").limit(10)
    respond_to do |format|
      format.html
      format.json { render :json => { :total => @artists.count, :artists => @artists } }
    end
  end

  collection_action :movie_artist_update1, :method => :post do
    defartist_score = %w[50 60 100 75]
    movie_id = params[:movie_id]
    score = params[:score]
    artist_type_id = params[:a]
    artist_id = params[:val]
    realesed_at = params[:realesed_date]
    exp_date = params[:exp_date]
    artist_score = params[:artist_score]
    p artist_score
    p artist_type_id
    p artist_id
    for i in 0...artist_type_id.length

      if MovieArtist.where("movie_id= ? and artist_type_id =?",movie_id,artist_type_id[i]).present?

        p "#{artist_type_id[i]}"
        @Movie_Artist = MovieArtist.where("movie_id= ? and artist_type_id =?",movie_id,artist_type_id[i]).first.id

        if artist_id[i].present?

          Movie_Artist = MovieArtist.where("movie_id= ? and artist_type_id =?",movie_id,artist_type_id[i]).first.id
          artist = MovieArtist.find(Movie_Artist)
          artist.destroy
          MovieArtist.create(:movie_id => movie_id, :artist_id => artist_id[i], :artist_type_id => artist_type_id[i])

        else
          if artist_score[i].present?
            MovieArtist.find(@Movie_Artist).update_attribute("artist_score",artist_score[i])
          end  
        end

        unless MovieArtist.find(@Movie_Artist).artist_score.present?
             MovieArtist.find(@Movie_Artist).update_attribute("artist_score",defartist_score[i])
        end

      else
        if artist_id[i].present?

         @Movie_Artists = MovieArtist.create(:movie_id => movie_id, :artist_id => artist_id[i], :artist_type_id => artist_type_id[i], :artist_score => artist_score[i])
         @Movie_Artist = @Movie_Artists.id

          unless MovieArtist.find(@Movie_Artist).artist_score.present?
             MovieArtist.find(@Movie_Artist).update_attribute("artist_score",defartist_score[i])
          end

        end
      end  
    end
    
    if score.present?
      p score
      Movie.find(movie_id).update_attribute("score",score)
    end 
    if realesed_at.present?
      Movie.find(movie_id).update_attribute("realesed_at","#{realesed_at}")
    end
    if exp_date.present?
      Movie.find(movie_id).update_attribute("tendtoreleased_at","#{exp_date}")
    end  
    redirect_to :back
  end  

  collection_action :update_movie_artist, :method => :post do
    description = params[:description]
    movie_id = params[:movie_id]
    movie_artists =  params[:movie_artists]
    @movie = Movie.find(movie_id)

    #description updation
    @movie.description = description
    
    logger.debug(movie_artists)
    movie_artists.each do |index, ma|
      type_id = ma['artist_type_id']
      artist_ids = ma['artist_ids']
      unless artist_ids.empty?
         ma = MovieArtist.where(:movie_id => movie_id, :artist_type_id => type_id.to_i)
         unless ma.empty?
           ma.each do |m|
             m.delete
           end
         end
        artist_ids.each do |aid|
        MovieArtist.create(:movie_id => movie_id, :artist_type_id => type_id.to_i, :artist_id => aid.to_i)
        end
        if Movie.find(movie_id).hero.present? && Movie.find(movie_id).heroine.present? && Movie.find(movie_id).director.present? && Movie.find(movie_id).music_director.present? && Movie.find(movie_id).producer.present? 
          @movie.edited = 1
          @movie.save
        else

        end   
      end 
    end
    #@movie.edited = 0
    #@movie.save
    #redirect_to :back
  end
  #movie_artist_update code in all movie_name show page
    collection_action :movie_artist_update, :method => :post do
        @defartist_score = Array.new
        @artist_type_ids = Array.new
        movie_artists = Array.new
        @defartist_score = [50, 60, 50, 100, 75]
        movie_score = params[:score]
        movie_id = params[:movie_id]
        movie_artists =  params[:movie_artists]
        p movie_artists
        realesed_at = params[:realesed_date]
        exp_date = params[:exp_date]
        artist_scores = Array.new
        artist_scores = params[:artist_scores]
        artist_scores.each do |index,ati|
              p artist_scores
              @artist_type_ids = ati['artist_type_id']
        end      
        puts artist_scores
        @movie = Movie.find(movie_id)
        unless movie_artists.nil?
            movie_artists.each do |index, ma|
              type_id = ma['artist_type_id']
              artist_ids = ma['artist_ids']
                unless artist_ids.nil?
                    ma = MovieArtist.where(:movie_id => movie_id, :artist_type_id => type_id.to_i)
                    unless ma.empty?
                        ma.each do |m|
                        m.delete
                       end
                    end
                    p artist_ids
                    artist_ids.each do |aid|
                        MovieArtist.create(:movie_id => movie_id, :artist_type_id => type_id.to_i, :artist_id => aid.to_i)
                    end
                end 
            end  
        end
         $i = 0   
        unless artist_scores.nil?
            
            artist_scores.each do |index,asc|
                artist_type_id = asc['artist_type_id']
                score = asc['artistscores']
                #p artist_type_id
                #p score
                #p $i
                as = Array.new
                as  = Movie.find(movie_id).movie_artists.where(:artist_type_id => artist_type_id.to_i).pluck(:id) 
                #p as
                
                unless as.nil?    
                    unless score.empty?
                        if as.count == 1
                            MovieArtist.find(as.first).update_attribute("artist_score", score.first)
                        else
                            (0...as.count).each do |a|
                                unless score[a].nil?
                                   MovieArtist.find(as[a]).update_attribute("artist_score", score[a])
                                else
                                   MovieArtist.find(as[a]).update_attribute("artist_score", @defartist_score[$i])          
                                end   
                            end 
                        end    
                    else
                        #as  = Movie.find(movie_id).movie_artists.where(:artist_type_id => artist_type_id.to_i).pluck(:id)
                        #p as
                        if as.count == 1
                            if MovieArtist.find(as.first).artist_score.nil?
                                p as.first
                                MovieArtist.find(as[0]).update_attribute("artist_score", @defartist_score[$i])
                            end    
                        else
                            (0...as.count).each do |a|
                                if MovieArtist.find(as[a]).artist_score.nil?
                                    MovieArtist.find(as[a]).update_attribute("artist_score", @defartist_score[$i])            
                                end    
                            end 
                        end       
                    end
                end 
                $i= $i+1   
            end   
        else
            @artist_type_ids.each do |ai|
                
                as  = Movie.find(movie_id).movie_artists.where(:artist_type_id => ai).pluck(:id)
                if as.count == 1
                    MovieArtist.find(as[0]).update_attribute("artist_score", @defartist_score[$i])
                else
                    (0...as.count).each do |a| 
                        MovieArtist.find(as[a]).update_attribute("artist_score", @defartist_score[$i])            
                    end 
                end
                $i = $i+1       
            end    
        end
        if movie_score.present?
            Movie.find(movie_id).update_attribute("score",movie_score)
        end

        if realesed_at.present?
          Movie.find(movie_id).update_attribute("realesed_at","'#{realesed_at}'")
        end

        if exp_date.present?
          Movie.find(movie_id).update_attribute("tendtoreleased_at","#{exp_date}")
        end 
    redirect_to :back 
    end  




    

    member_action :duplicate_movies, :method => :get do
        @movie=Movie.find(params[:id])
        len=@movie.name.length
        @duplicate=Movie.where('id != ? and name like ?',@movie.id,"#{@movie.name[0]}%#{@movie.name[len-1]}")
        render :duplicates     
    end

    member_action :duplicate_movie_delete, :method => :post do
        @movie=Movie.find(params[:id])
        @dup_movie=Movie.find(params[:dmovie_id])
        @posts=@dup_movie.posts
        if @posts.present?
            @posts.each do |p|
              p.update_attribute(:posting_id,@movie.id)
            end
        end  
        total=@movie.posts.count
        @dup_movie.destroy
        render :js=>"alert('succefully transfered posts deleting duplicate');$('#act#{@movie.id}').text(#{total});$('#dup#{@dup_movie.id}').html('<p>removed<p>');"
    end
  
    form do |f|
      	f.inputs 'create movie' do 
      		f.input :name
            f.has_many :artist_types do |at|
                at.input :name, :label => 'Artist Type', :as => :select, 
                  :collection => ArtistType.all.map{ |u| [u.name, u.id] }
                at.has_many :artists do |a|
                  a.input :name, :label => 'Artist', :as => :select, 
                  :collection => Artist.all.map{ |u| [u.name, u.id] },
                  :multiple => true
                end
            end
        end
      	f.buttons
    end
end
