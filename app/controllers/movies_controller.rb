class MoviesController < ApplicationController

  def index
    options = {:page => (params[:page]||1), :per_page=> (params[:per_page] || 10)}
    @movies = Movie.tire.search(options) do
      query {all}
      #sort { by :id => 'desc' }
      sort do
        #by :id => 'desc'
        by :thumb_movie_image_present => 'desc', :id => 'desc'
      end
    end
    if request.xhr?
      render :layout => false
    else 
      render :layout => true
    end
  end 

  def query
    @movies = Movie.search_for("*#{params[:q]}*")
    @ret = []
    @movies.each do |movie|
      @ret << { :name => movie.name, :year => movie.year, :id => movie.id, :movie_image => movie.movie_image.url(:thumb) }
    end

    respond_to do |format|
      format.html
      format.json { render :json => { :total => @movies.count, :movies => @ret } }
    end
  end
   
  def show
    @movie = Movie.friendly.find(params[:id])
    @wood = Wood.find(@movie.wood_id)
    @related_movies = @movie.related_movies.order("weight DESC")
    @reviews = Review.where(:movie_id => params[:id])
    @rating = Rating.where(:movie_id => params[:id])
    @cast = Movie.cast_involved(@movie)
    
    #@related_posts = Related_posts.where(:movie_id => @movie.id)
    #@relatemovies = Movie.all
    @posts = Post.where(:posting_type => "Movie", :posting_id => @movie.id)
    @fans_count = Movie.find(@movie.id).fans.count

    
    @movie_posts = Post.where(:posting_type => "Movie", :posting_id => @movie.id)

    if current_user
      @movie.watches.create(:user_id=>current_user.id)
      @friends = Friend.where(:friend_id => current_user.id)
    else
      @movie.watches.create(:cuid=>session[:cuid])
    end

    if request.xhr?
      render :layout => 'dialogue'
      @xhr_request = true
    else
      @xhr_request = false
    end
  end

  def profile
    @artist = Artist.where(:name => params[:artist]).first
  end

  def preferences_of_movies
    user_id = params[:user_id]
    movie_ids = params[:movie_ids]
    movie_ids.each do |movie_id|
      Movie.find(movie_id).fans.create(:user_id => params[:user_id])
    end
    redirect_to root_url
  end

  def preferences_of_languages
    wood_ids = params[:wood_ids]
    unless wood_ids.nil?
      wood_ids.each do |wood_id|
        Wood.find(wood_id).fans.create(:cuid => session[:cuid])
      end
      movie_ids = []
      wood_ids.each do |w|
         movie_ids = movie_ids + Wood.find(w).movies.map(&:id)
      end
      posts = Post.where(:posting_type => "Movie", :posting_id => movie_ids)
      cuid = session[:cuid]
      posts.each do |p|
        ua = UserActivity.where(:post_id => p.id, :cuid => cuid).first
        if ua.nil?
          if (p.postable_type == "News")
          image_id = News.find(p.postable_id).image_id
          image_url = Image.find(image_id).image.url(:thumb).to_s
          thumb_height = Image.find(image_id).thumb_height
          elsif (p.postable_type == "Image")
            image_id = Image.find(p.postable_id).id
            image_url = Image.find(image_id).image.url(:thumb).to_s
            thumb_height = Image.find(image_id).thumb_height
          elsif (p.postable_type == "Album")
            image_id = Album.find(p.postable_id).images.first.id
            image_url = Image.find(image_id).image.url(:thumb).to_s
            thumb_height = Image.find(image_id).thumb_height
          elsif (p.postable_type == "Video")
            video_id = Video.find(p.postable_id).id
            if Rails.env == 'production'
              image_url = "http://d2tgu4jwper4r3.cloudfront.net/video_images/#{video_id}.jpg"
            elsif Rails.env == 'development'
              image_url = "http://d154rvuufl6jl1.cloudfront.net/video_images/#{video_id}.jpg"
            end
            thumb_height = 360
          end

          user_activity = UserActivity.create(:post_id => p.id, :post_image => image_url, :post_title => p.title, 
                :post_type => p.postable_type, :post_created_on => p.created_at , :image_thumb_height => thumb_height,
                :cuid => cuid)
        end
      end
      redirect_to root_url
    end
  end

  def user_movie_create
    name = params[:name]
    @movie = Movie.create(:name => name, :wood_id => 1)
    username = current_user.username
    if Rails.env == 'production'
      Sample.movie_create(@movie.name, username).deliver!
    end
    respond_to do |format|
        format.js
    end
  end

  def user_movie_rating_create
    user_id = params[:user_id]
    movie_id = params[:movie_id]
    score = params[:rating]
    @rates = Rate.create(:score => score)
    username = current_user.username
    
    respond_to do |format|
        format.js
    end
  end

  def movie_fan
    movie_id = params[:movie_id]
    user_id = current_user.id
    fan = Fan.where(:fan_id => movie_id, :fan_type => "Movie", :user_id => user_id).first
    if fan.nil?
      movie = Movie.find(movie_id)
      movie.fans.create(:user_id => user_id)
      posts = Post.where(:posting_type => "Movie", :posting_id => movie_id)
      posts = posts.uniq
      Post.fan_follow_feed(posts,user_id)

      #user score
      action_score = Score.create(:user_id => current_user.id, :score => 10, 
        :action => "Fan || Movie || #{movie.name} || id[#{movie.id}]")
      total_score = action_score.score
      current_user.score += total_score
      current_user.save
    end
    #if request.xhr?
     # render :json => {"success" => true}.to_json
    #else
      redirect_to :back
    #end
  end

  def artist_fan
    artist_id = params[:artist_id]
    user_id = params[:user_id]
    fan = Fan.where(:fan_id => artist_id, :fan_type => "Artist", :user_id => user_id).first
    if fan.nil?
      artist = Artist.find(artist_id)
      artist.fans.create(:user_id => user_id)
      posts = Post.where(:posting_type => "Artist", :posting_id => artist_id)
      artist_type_id = MovieArtist.where(:artist_id => artist_id).map(&:artist_type_id).first
      hero = ArtistType.find_by_name("Hero")
      director = ArtistType.find_by_name("Directed by")
      if (artist_type_id == hero.id || artist_type_id == director.id)
        movie_artist_ids = MovieArtist.where(:artist_id => artist_id).map(&:movie_id)
        posts = posts + Post.where(:posting_type => "Movie", :posting_id => movie_artist_ids)
      end
      posts = posts.uniq

      #user score
      action_score = Score.create(:user_id => current_user.id, :score => 10, 
        :action => "Fan || Artist || #{artist.name} || id[#{artist.id}]")
      total_score = action_score.score
      current_user.score += total_score
      current_user.save


      Post.fan_follow_feed(posts,user_id)
    end 
    if request.xhr?
      render :json => {"success"=>true}.to_json
    else   
      redirect_to :back
    end
  end

  def cast_crew
    movie_id = params[:movie_id]
    @movie = Movie.find(movie_id)
    @cast = Movie.cast_involved(@movie)
    render :layout => false
  end

  def fans
    movie_id= params[:movie_id]
    @fans = Movie.find(movie_id).fans
    render :layout => false
    
  end
  def photos
    movie_id= params[:movie_id]
    @posts = Post.where(:posting_type => "Movie", :posting_id => movie_id, :postable_type => 'Image')
    render :layout => false
    
  end
  def related_posts
    movie_id= params[:movie_id]
    @related_posts = Post.where(:posting_type => "Movie", :posting_id => movie_id)
    render :layout => false
  end

  def relatedmovies
    movie_id= params[:movie_id]
    @related_movies = RelatedMovie.where(:movie_id => movie_id)
    render :layout => false
  end

  def activities
    logger.debug(params[:id])
    @posts = Post.where(:posting_type => "Movie", :posting_id => params[:id])
    render layout: false
  end

  def movie_reviews
    rating = 0
    analysis= params[:analysis]
    movie_id = params[:movie_id]
    user_id = params[:user_id]
      unless user_id.nil?
        Review.create(:movie_id => movie_id, :analysis => analysis, :rating => rating, :user_id => user_id)
        @reviews = Review.where(:movie_id => movie_id).order("id desc").limit(5)
      end  
      redirect_to :back
  end

  def load_reviews
    movie_id = params[:movie_id]
    @reviews = Review.where(:movie_id => movie_id ).order("id desc").limit(5)
    render :layout=>false
  end
 
  def reviews_like
    user_id = params[:user_id]
    review_id = params[:review_id]
    value = params[:value]
     Review.find(review_id).likes.create(:user_id => user_id, :value => value)
    redirect_to :back
  end

  def load_review_likes
    review_id = params[:review_id]
    @reviews_count = Review.find(review_id).likes.where(:value=> 1).count
    render :layout=>false

  end  

  def movie_ratings
    user_id = params[:user_id]
    movie_id = params[:movie_id]
    rating = params[:rating]
    #@userid = Rating.where(:user_id => user_id, :movie_id => movie_id)
    #@cuid = Rating.where(:cuid => session[:cuid], :movie_id => movie_id)
      if current_user
          movie_ratings = Rating.create(:user_id => user_id, :movie_id => movie_id, :rating => rating)
      else
          movie_ratings = Rating.create(:cuid=> session[:cuid], :movie_id => movie_id, :rating => rating)
      end 
      redirect_to :back   
  end
  def load_movie_rating

      movie_id = params[:movie_id]
      @rating = Rating.where(:movie_id => movie_id)
      render :layout=>false
      
  end
  def load_moviefans_count

      movie_id = params[:movie_id]
      @fans_count = Movie.find(movie_id).fans.count
      render :layout=>false
      
  end
  
  def load_artistfans_count

    artist_id = params[:artist_id]
      @artist_id = artist_id
      @artistfans_count = Artist.find(artist_id).fans.count
      render :layout=>false
  end  

  def upload
    @movie=Movie.find(params[:id])    
   # File.open(Rails.root.join('public','uploads','movies',@image.original_filename),'wb')do |myfile|
    #   myfile.write(@image.read)
    #end
    @movie.movie_image=params[:movie_image]
    @movie.save!
    redirect_to :back  
  end  

  def get_movie_name
    val = params[:val]
    @movie = Movie.find(val)
    respond_to do |format|
        format.js
    end
  end
  def autocompleat_movie
    puts params[:q]
    @movies = Movie.search_for("*#{params[:q]}*")
    @ret = []
    @movies.each do |movie|
      @ret << { :name => movie.name, :year => movie.year, :id => movie.id, :movie_image => movie.movie_image.url(:thumb) }
    end

    respond_to do |format|
      format.html
      format.json { render :json => {:movies => @ret } }
    end
  end

  def navigation
    begin
      query = params[:query]
      if query.split("_")[0] == "create-artist"
        @type = "Artist"
        artist_id = query.split("_")[1].split("-")[0]
        @type_name = Artist.find(artist_id).name
      elsif query.split("_")[0] == "create-movie"
        @type = "Movie"
        movie_id = query.split("_")[1].split("-")[0]
        @type_name = Movie.find(movie_id).name
      elsif query.split("_")[0] == "create-event"
        @type = "Event"
        event_id = query.split("_")[1].split("-")[0]
        @type_name = Event.find(event_id).name
      end
      p_type = query.split("_")[2].split("-")[1]
      if p_type == "image"
        @p_type = "Image"
      elsif p_type == "news"
        @p_type = "News"
      elsif p_type == "video"
        @p_type = "Video"
      elsif p_type == "album"
        @p_type = "Album"
      end
    rescue
    end
    render :layout => false
  end


end
