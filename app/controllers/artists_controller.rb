class ArtistsController < ApplicationController

  def index
    options = {:page => (params[:page]||1), :per_page=> (params[:per_page] || 20)}
    @artists = Artist.tire.search(options) do
      query {all}
      #sort { by :id => 'desc' }
      sort do
      #  by :id => 'desc'
        by :thumb_artist_image_present => 'desc', :id => 'desc'
      end
    end
  end 



  def query
    @artists = Artist.search_for("*#{params[:q]}*")
    respond_to do |format|
      format.html
      format.json { render :json => { :total => @artists.count, :artists => @artists } }
    end
  end

  def show
    @artist = Artist.friendly.find(params[:id])
  end

  def preferences_of_artists
    user_id = params[:user_id]
    artist_ids = params[:artist_ids]
    artist_ids.each do |artist_id|
      Artist.find(artist_id).fans.create(:user_id => params[:user_id])
    end
    redirect_to root_url
  end

  def user_artist_create
    name = params[:name]
    @artist = Artist.create(:name => name)
    username = current_user.username
    if Rails.env == 'production'
      Sample.artist_create(@artist.name, username).deliver!
    end
    respond_to do |format|
        format.js
    end
  end

  def artist_fan
    artist_id = params[:artist_id]
    user_id = current_user.id
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
    redirect_to :back
  end

  def involved_movies
    @artist = Artist.find(params[:artist_id])
    @people = Artist.people_involved(@artist)
    render :layout => false
  end

  def movie_artists_quick_edit
    movie_id = params[:movie_id]
    description = params[:description]

    movie = Movie.find(movie_id)

    movie.description = description

    movie.save

    Movie.update_all({:edited => true}, {:id => movie_id})

    redirect_to "/admin/movies/" + movie_id , notice: "Movie updated"
  end

  def upload
    @artist=Artist.find(params[:id])   
   # File.open(Rails.root.join('public','uploads','movies',@image.original_filename),'wb')do |myfile|
    #   myfile.write(@image.read)
    #end
    @artist.artist_image=params[:artist_image]
    @artist.save!
    redirect_to :back  
  end

  def birthday
    dat=Date.today 
    dat.month<10 ? (mon="0#{dat.month}") : (mon=dat.month) 
    dat.day<10 ? (day="0#{dat.day}") : (day=dat.day)
    @artist=Artist.where('dob like ?',"%-#{mon}-#{day}").limit(5)
    @year=dat.year 
    render :layout=>false
  end

  def bday_greeting
    @artist=Artist.find(params[:id])
    @artist.wishes.create(:greeting=>params[:greeting],:user_id=>params[:user_id])

    render :js=>"$('##{@artist.id}com').html('<br/><br/><h4 style=background-color:#DDDDDD;>greetings successfully reached..</h4>');" 
  end

  def get_artist_name
    val = params[:val]
    @artist = Artist.find(val)
    respond_to do |format|
        format.js
    end
  end

  def posts
    @artist = Artist.friendly.find(params[:id])
    @artist_posts = @artist.posts
  end

  def photos
    @artist = Artist.friendly.find(params[:id])
    image_ids = Photo.where(:artist_id => @artist.id, :deleted => false).collect(&:image_id)
    @images = []
    image_ids.each do |i|
      @images << Image.where(:id => i).first
    end
  end

  def videos
    @artist = Artist.friendly.find(params[:id])
    @videos = Post.where(:postable_type => "Video", :posting_type => "Artist", :posting_id => @artist.id)
  end

  def movies
    @artist = Artist.friendly.find(params[:id])
  end


end












