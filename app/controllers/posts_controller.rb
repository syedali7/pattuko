class PostsController < ApplicationController

  before_filter :authenticate_user!, :only => [:album_create, :news_create, :video_create, :image_create]

  def create_popup_code
    render :layout => false
  end

  def edit_post_popup_code
    render :layout => false
  end

  #caches_page :index
  def index
=begin
    options = {:page => (params[:page]||1), :per_page=> (params[:per_page] || 20)}
    @posts = Post.tire.search(options) do
      query {all}
      facet 'movie' do
        terms :movie
      end
      facet 'artist' do
        terms :artist
      end
      sort { by :id => 'desc' }
    end
    @page = params[:page]||1
    if request.xhr?
      render :layout => false
    else 
      render :layout => true
    end
=end
  @movie = params[:movie]
  @artist = params[:artist]
  end   

  def facet_search 
    movie = params[:movie]
    artist = params[:artist]
    options = {:page => (params[:page]||1), :per_page=> (params[:per_page] || 20)}
    @posts = Post.tire.search(options) do
      query {all}
      unless movie.nil?
        filter :terms, :movie => [movie.to_s]
      end
      unless artist.nil?
         filter :terms, :artist => [artist.to_s]
      end
      facet 'movie' do
        terms :movie
      end
      facet 'artist' do
        terms :artist
      end
      sort { by :id => 'desc' }
    end
    @page = params[:page]||1
    render template: "posts/index"
  end

  def top_search 
    title = params[:search_term]
    options = {:page => (params[:page]||1), :per_page=> (params[:per_page] || 20)}
    @posts = Post.tire.search(options) do
      query do 
        boolean do
          should { string 'title:'+ title + '*'}
          should { string 'movie:'+ title + '*'}
          should { string 'artist:'+ title + '*'}
        end
      end
      facet 'movie' do
        terms :movie
      end
      facet 'artist' do
        terms :artist
      end
      sort { by :id => 'desc' }
    end
    @page = params[:page]||1
    render template: "posts/index"
  end

  def event_query
    @events = Event.search_for("*#{params[:q]}*")
    @ret = []
    @events.each do |event|
      @ret << { :name => event.name, :id => event.id }
    end

    respond_to do |format|
      format.html
      format.json { render :json => { :events => @ret } }
    end
  end

  def show
    begin
      @post  = Post.friendly.find(params[:id])
      @people = @post.people_involved
      @recent_posts = Post.where(:postable_type => "News").limit(3).order("created_at desc")

      #@posts = Post.page(params[:page]).per(20)
      @related_posts = @post.related_posts.order("weight desc").page(params[:page]).per(20)
      if current_user
        @post.watches.create(:user_id=>current_user.id)
      else
        @post.watches.create(:cuid=>session[:cuid])
      end
      if request.xhr?
        render :layout => false
        @xhr_request = true
      else
        #render :layout => 'fixed'
        @xhr_request = false
      end
    rescue ActiveRecord::RecordNotFound
      post_id = (params[:id])
      e = Error.where(:post_id => post_id).first
      if e.nil?
        Error.create(:post_id => post_id, :description => "Post not found")
      end
      flash[:notice] = "Successfully saved!"
      redirect_to root_url
    end
    
  end

  def related_posts
    @related_posts = RelatedPost.where(:post_id => params[:post_id]).order("weight desc").page(params[:page]).per(20)
    render :layout => false
  end

  def new
    @post = Post.new
    render :layout => false
  end

  def create
    @post = @postable.posts.new(params[:post])
    if @post.save
      redirect_to [@postable, :posts], notice: "Post created."
    else
      render :new
    end
  end

  def news_create

    title = params[:title]
    source_name = params[:source_name]
    content = params[:content]
    description = params[:description]
    img = params[:image]
    movie_id = params[:movie_id]
    artist_id = params[:artist_id]
    image_id = params[:image_id]
    user_id = current_user.id
    type = params[:posting_type]
    tmp = type.split('-')[1]
    type_string = tmp.split('_')[0]
    type_id = tmp.split('_')[1]

    posting_type = ''

    if type_string == "movie"
      posting_type = 'Movie'
    elsif type_string == "artist"
      posting_type = 'Artist'
    elsif type_string == "event"
      posting_type = 'Event'
    end

    post_to_facebook = params[:post_to_facebook]
    news = News.create(:content => content, :image_id => image_id, :source_name => source_name)
    post = Post.create( :title => title , :posting_id => type_id, :description => description,
         :posting_type => posting_type, :postable_type => 'News', :postable_id => news.id , 
          :user_id => user_id, :post_to_facebook => post_to_facebook )
    if session[:admin]
      Post.mention(post,params[:mention_artist_id],params[:mention_movie_id])
    end
    
    #user score
    action_score = Score.create(:user_id => current_user.id, :score => 20, :action => "Post created || News || post id is #{post.id}")
    total_score = current_user.score + action_score.score
    current_user.score = total_score
    current_user.save

    scrap_hash = {}
 
    PostsWorker.perform_async(post.id,1,scrap_hash)

    #inserting this particular post to the current user feed
    feed = Feed.create(:user_id => user_id ,:post_id => post.id, :post_created_on => post.created_at )
        
    PostsWorker.perform_async(post.id,2,scrap_hash)

    #posting news to user facebook wall
    if Rails.env == 'production'
      if post_to_facebook
        text = "I've Posted the News here.."
        Post.news_post_to_facebook(post,text,news,current_user)
      end
    end
    redirect_to root_url
  end

  def video_create
    title = params[:title]
    description = params[:description]
    #video_type = params[:video_type]
    #logger.debug(video_type)
    youtube_url = params[:youtube_url]
    movie_id = params[:movie_id]
    artist_id = params[:artist_id]
    user_id = current_user.id
    type = params[:posting_type]
    tmp = type.split('-')[1]
    type_string = tmp.split('_')[0]
    type_id = tmp.split('_')[1]
    posting_type = ''

    if type_string == "movie"
      posting_type = 'Movie'
    elsif type_string == "artist"
      posting_type = 'Artist'
    elsif type_string == "event"
      posting_type = 'Event'
    end

    post_to_facebook = params[:post_to_facebook]

    begin 
        url_split1,url_split2 = youtube_url.split('/watch?')
        if url_split2[0] == "f"
          c,d = url_split2.split('v=')
          youtube_url = url_split1 + '/watch?v=' + d
        elsif url_split2[0] == "v"
          a,b = url_split2.split('&feature')
          youtube_url = url_split1 + '/watch?' + a
        end
        s1,s2 = youtube_url.split('/watch?v=')
        embed_add = s1 + "/embed/" + s2
        youtube_embed_code = embed_add + "?autoplay=1"
        domain,code = youtube_url.split('watch')
        domain_split1,domain_split2 = domain.split('www')
        code_split,code_url = code.split('=')
        youtube_code = domain_split1+'img'+domain_split2+'vi/'+code_url+'/0.jpg'
        video = Video.create(:youtube_url => youtube_embed_code,:youtube_code => youtube_code) #:video_type => video_type )
        post = Post.create( :title => title ,:description => description, :posting_id => type_id, 
          :posting_type => posting_type , :postable_type => 'Video', 
          :postable_id => video.id, :user_id => user_id ,:post_to_facebook => post_to_facebook)

        if session[:admin]
          Post.mention(post,params[:mention_artist_id],params[:mention_movie_id])
        end

        #inserting this particular post to the current user feed
        feed = Feed.create(:user_id => user_id ,:post_id => post.id, :post_created_on => post.created_at )

        #user score
        action_score = Score.create(:user_id => current_user.id, :score => 20, :action => "Post created || Video || post id is #{post.id}")
        total_score = action_score.score
        current_user.score += total_score
        current_user.save

        scrap_hash= {}
        
        PostsWorker.perform_async(post.id,1,scrap_hash)

        PostsWorker.perform_async(post.id,2,scrap_hash)

    rescue
        flash['notice'] = "unable to upload with this url.. Give url in this format [http://www.youtube.com/watch?v=sDIA0mkcpRI]"
    end
        redirect_to root_url, notice: "Video was successfully Uploaded."
  end

  def album_create
    title = params[:title]
    description = params[:description]
    album_name = params[:album_name]
    movie_id = params[:movie_id]
    artist_id = params[:artist_id]
    cover_image_id = params[:cover_image_id]
    user_id = current_user.id

    type = params[:posting_type]
    tmp = type.split('-')[1]
    type_string = tmp.split('_')[0]
    type_id = tmp.split('_')[1]
    
    posting_type = ''
    
    if type_string == "movie"
      posting_type = 'Movie'
    elsif type_string == "artist"
      posting_type = 'Artist'
    elsif type_string == "event"
      posting_type = 'Event'
    end

    album = Album.create(:album_name => album_name)
    images_ids = params[:image_ids]
    post_to_facebook = params[:post_fb]
    images_ids.each do |image_id|
      AlbumImage.create(:album_id => album.id, :image_id => image_id)
    end

    if cover_image_id.empty?
      album.cover_image_id = images_ids[0]
    else
      album.cover_image_id = cover_image_id
    end

    album.save

    post = Post.create( :title => title ,:description => description, :posting_id => type_id, 
    :posting_type => posting_type , :postable_type => 'Album',
    :postable_id => album.id, :user_id => user_id,:post_to_facebook => post_to_facebook)

    if session[:admin]
      Post.mention(post,params[:mention_artist_id],params[:mention_movie_id])
    end

    #inserting this particular post to the current user feed
    feed = Feed.create(:user_id => user_id ,:post_id => post.id, :post_created_on => post.created_at )

    #user score
    action_score = Score.create(:user_id => current_user.id, :score => 20, :action => "Post created || Album || post id is #{post.id}")
    total_score = action_score.score
    current_user.score += total_score
    current_user.save

    scrap_hash = {}

    PostsWorker.perform_async(post.id,1,scrap_hash)
    PostsWorker.perform_async(post.id,2,scrap_hash)

    redirect_to root_url
  end

  def image_create
    title = params[:title]
    img = params[:image]
    movie_id = params[:movie_id]
    artist_id = params[:artist_id]
    image_id = params[:image_id]
    user_id = current_user.id
    type = params[:posting_type]
    tmp = type.split('-')[1]
    type_string = tmp.split('_')[0]
    type_id = tmp.split('_')[1]
    posting_type = ''

    if type_string == "movie"
      posting_type = 'Movie'
    elsif type_string == "artist"
      posting_type = 'Artist'
    elsif type_string == "event"
      posting_type = 'Event'
    end

    post_to_facebook = params[:post_to_facebook]
    post = Post.create( :title => title , :posting_id => type_id,
         :posting_type => posting_type, :postable_type => 'Image', 
         :postable_id => image_id , :user_id => user_id,:post_to_facebook => post_to_facebook)

    if session[:admin]
      Post.mention(post,params[:mention_artist_id],params[:mention_movie_id])
    end

    #inserting this particular post to the current user feed
    feed = Feed.create(:user_id => user_id ,:post_id => post.id, :post_created_on => post.created_at )

    #user score
    action_score = Score.create(:user_id => current_user.id, :score => 20, :action => "Post created || Image || post id is #{post.id}")
    total_score = action_score.score
    current_user.score += total_score
    current_user.save

    scrap_hash ={}

    PostsWorker.perform_async(post.id,1,scrap_hash)

    PostsWorker.perform_async(post.id,2,scrap_hash)

    #posting that image to his facebook wall
    if Rails.env == 'production'
      if post_to_facebook
        text = "I've Posted the Image here.."
        Post.image_post_to_facebook(post,text,current_user)
      end
    end
    
    redirect_to root_url
  end

  def review_create
    movie_id = params[:movie_id]
    user_id = current_user.id
    rating = params[:rating]
    punchline = params[:punchline]
    analysis = params[:analysis]
    post_to_facebook = params[:post_to_facebook]
    movie = Movie.find(movie_id)
    title = movie.name + " Movie Review"
    r = Random.new
    random_id = r.rand(1...9)
    random_movie = Movie.find(random_id)
    movie_image = random_movie.movie_image.url(:medium)

    review = Review.create(:rating => rating, :analysis => analysis, 
      :punchline => punchline, :movie_image => movie_image)

    posting_type = 'Movie'
    post = Post.create( :title => title , :posting_id => random_movie.id,
           :posting_type => posting_type, :postable_type => 'Review', 
           :postable_id => review.id , :user_id => user_id,:post_to_facebook => post_to_facebook)

    redirect_to root_url
  end
  
  def load_comments
    @comments = Post.find(params[:post_id]).comments
    @post = Post.find(params[:post_id])
    render :layout => false
  end

  def load_news
    @post =  Post.where(:postable_type => "News")
  end 

  def load_movies
    @post = Post.where(:posting_type => "Movie")
  end

  def load_artists
    @post = Post.where(:posting_type => "Artist")
  end

  def load_albums
    @post =  Post.where(:postable_type => "Album").page(params[:page]).per(2)
  end

  def news
    @post =  Post.where(:postable_type => "News").page(params[:page]).per(20)
  end

  def movies
    @post = Post.where(:posting_type => "Movie").page(params[:page]).per(20)
  end

  def artists
    @post = Post.where(:posting_type => "Artist").page(params[:page]).per(20)
  end

  def albums
    @post =  Post.where(:postable_type => "Album").page(params[:page]).per(20)
  end

  def follow_movies
    unless current_user.nil? 
      movie_ids = Fan.where(:user_id => current_user.id, :fan_type => 'Movie').map(&:fan_id).uniq
      if movie_ids.empty?
        @movies = Movie.all(:limit => 9)
      else
        @movies = Movie.find(:all, :conditions => ['id not in (?)', movie_ids],:limit => 9)
      end
    end

    render :layout => false
  end

  def follow_artists
    unless current_user.nil? 
      artist_ids = Fan.where(:user_id => current_user.id, :fan_type => 'Artist').map(&:fan_id).uniq
      if artist_ids.empty?
        @artists = Artist.all(:limit => 9)
      else
        @artists = Artist.find(:all, :conditions => ['id not in (?)', artist_ids],:limit => 9)
      end
    end
    render :layout => false
  end

  def wood_selection
    @woods = Wood.all
    render :layout => false
  end

  

  def favourite
    post_id = params[:post_id]
    user_id = current_user.id
    favourites = Favourite.where(:user_id => current_user.id, :favourable_id => post_id, :favourable_type => 'Post').first
    if favourites.nil?
      fav = Post.find(post_id).favourites.create(:user_id => user_id)
    end
    redirect_to :back
  end

  def hover_content
    post_id = params[:post_id]
    @post = Post.find(post_id)
    if @post.posting_type == 'Movie'
      @movie = Movie.find(@post.posting_id)
    elsif @post.posting_type == 'Artist'
      @artist = Artist.find(@post.posting_id)
    elsif @post.posting_type == 'Event'
      event = Event.find(@post.posting_id)
      if event.eventable_type == "Movie"
        @movie = Movie.find(event.eventable_id)
      elsif event.eventable_type == "Artist"
        @artist = Artist.find(event.eventable_id)
      end
    end
    render :layout => false
  end

  def clap
    post_id = params[:post_id]
    user_id = current_user.id
    claps = Clap.where(:user_id => current_user.id, :clap_id => post_id, :clap_type => 'Post').first
    if claps.nil?
      post = Post.find(post_id)
      clap = post.claps.create(:user_id => user_id)

      #scores to the users
      post_created_user = User.find(post.user_id)

      Notification.create(
        :user_id => post.user_id,
        :friend_id => user_id, 
        :notification=>"#{ current_user.username } clapped your post",
        :friend_name=>current_user.username
      )
      Sample.user_notification("#{current_user.username} clapped your post",post_created_user.email, post).deliver

      clapped_score = Score.create(:user_id => current_user.id, :score => 3, :action => "clapped for the post id is #{post_id}")
      owner_score = Score.create(:user_id => post_created_user.id, :score => 1, 
        :action => "User id[#{current_user.id}] clapped User id [#{post_created_user.id}]'s post.. Post id [#{post_id}]") 
      clapped_total_score = clapped_score.score
      current_user.score += clapped_total_score
      current_user.save

      owner_total_score = owner_score.score
      post_created_user.score += owner_total_score
      post_created_user.save

      #posting to facebook wall
      if Rails.env == 'production'
        if post.postable_type == "Image"
          text = "Wow! awesome! I've clapped this Image!"
          Post.image_post_to_facebook(post,text,current_user)
        elsif post.postable_type == "News"
          news = News.find(post.postable_id)
          text = "Wow!! awesome!! I've clapped this post!!"
          Post.news_post_to_facebook(post,text,news,current_user)
        end
      end

    end
    redirect_to :back
  end

  def more_people_involved
    @post = Post.find(params[:post_id])
    @people = @post.people_involved
    render :layout => false
  end

  def fan_follow
    post_id = params[:post_id]
    user_id = current_user.id
    post = Post.find(post_id)
    posting_type = post.posting_type
    posting_id = post.posting_id
    if posting_type == "Movie"
      Post.fan_follow_movie_via_post(user_id, posting_type, posting_id)
    elsif posting_type == "Artist"
      Post.fan_follow_artist_via_post(user_id, posting_type, posting_id)
    elsif posting_type == "Event"
      event = Event.find(posting_id)
      if event.eventable_type == "Movie"
        posting_id = event.eventable_id
        posting_type = event.eventable_type
        Post.fan_follow_movie_via_post(user_id, posting_type, posting_id)
      elsif event.eventable_type == "Artist"
        posting_id = event.eventable_id
        posting_type = event.eventable_type
        Post.fan_follow_artist_via_post(user_id, posting_type, posting_id)
      end
    end
    redirect_to :back
  end

  
  def block
    @post=Post.find(params[:id])
    Sample.block(@post,current_user).deliver

    if @post.flaged==true||@post.trusted==true
       render :js=>"alert('The Content Is Valid!');" and return
    else   
      @post.update_attribute(:flaged,false)
      respond_to do|format|
        format.html {redirect_to :back } 
        format.js 
       end
    end  
  end

  def show_page_comment
    post = Post.find(params[:post_id])
    post.comments.create(:body => params[:content], :user_id => current_user.id)

    #user score
    post_created_user = User.find(post.user_id)
    commented_score = Score.create(:user_id => current_user.id, :score => 5, 
                      :action => "Commented on the post id[#{post.id}]")
    owner_score = Score.create(:user_id => post_created_user.id, :score => 3, 
                  :action => "User id[#{current_user.id}] commented on User id [#{post_created_user.id}]'s post.. Post id [#{post.id}]") 
    commented_total_score = commented_score.score
    current_user.score += commented_total_score
    current_user.save

    owner_total_score = owner_score.score
    post_created_user.score += owner_total_score
    post_created_user.save

    redirect_to :back
  end

  def home_page_comment
    post = Post.find(params[:post_id])
    post.comments.create(:body => params[:content], :user_id => current_user.id)

    #user score
    post_created_user = User.find(post.user_id)
    commented_score = Score.create(:user_id => current_user.id, :score => 5, 
                      :action => "Commented on the post id[#{post.id}]")
    owner_score = Score.create(:user_id => post_created_user.id, :score => 3, 
                  :action => "User id[#{current_user.id}] commented on User id [#{post_created_user.id}]'s post.. Post id [#{post.id}]") 
    commented_total_score = commented_score.score
    current_user.score += commented_total_score
    current_user.save

    owner_total_score = owner_score.score
    post_created_user.score += owner_total_score
    post_created_user.save

    redirect_to :back
  end 

  def comment_load_homepage
    @comments = Post.find(params[:post_id]).comments
    @post = Post.find(params[:post_id]) 
    render :layout => false
   end 

  def load_show_page_comments
    @comments = Post.find(params[:post_id]).comments
    @post = Post.find(params[:post_id])
    render :layout => false    
  end

  def load_home_page_comments
    @comments = Post.find(params[:post_id]).comments
    @post = Post.find(params[:post_id])
    render :layout => false    
  end

  def load_fans_count
    @post = Post.find(params[:post_id])
    render :layout => false
  end

  def user_event_create
    name = params[:name]
    @event = Event.create(:name => name)
    username = current_user.username
    if Rails.env == 'production'
      Sample.event_create(@event.name, username).deliver!
    end
    respond_to do |format|
        format.js
    end
  end

  def update
    if (params[:post][:posting_type]=='Movie')&&(params[:edit_movie_id]!="")
     Post.find(params[:id]).update_attributes(:posting_id=>params[:edit_movie_id],:posting_type=>params[:post][:posting_type])
     flag=true
    elsif (params[:post][:posting_type]=='Artist')&&(params[:edit_artist_id]!="")
      Post.find(params[:id]).update_attributes(:posting_id=>params[:edit_artist_id],:posting_type=>params[:post][:posting_type])
      flag=true
    end 
    if flag
     respond_to do|format|
	       format.js {render :js=>"alert('you are successful in updation')"}
     end
    else
     respond_to do|format|
         format.js {render :js=>"alert('you cannot update without selecting movie or artist name');"}
     end
    end 
  end

  def destroy
     @post=Post.find(params[:id])
     begin
      @feed=Feed.where(:post_id=>@post.id)
     rescue ActiveRecord::RecordNotFound
    end
      if @feed
        @feed.each do|f|
            f.destroy
        end
      end
      @post.destroy
     redirect_to :back
  end

  def trusted
    post = Post.find(params[:post_id])

    if post.trusted 
       post.trusted=false
       post.save
       render :text=>"untrusted",:layout=>false and return
    else 
       post.trusted=true
       post.save
       render :text=>"trusted",:layout=>false and return
    end
  end

  def trending
    post=Post.find(params[:id])
    if post.trending 
       post.trending=false
       post.save
       render :text=>"trending",:layout=>false and return
    else 
       post.trending=true
       post.save
       render :text=>"un trend",:layout=>false and return
    end  
  end

  def polling
    posting_id = params[:posting_id]
    posting_type = params[:posting_type]
    options = params[:options]
    question = params[:question]

    if posting_type == 'Movie'
      movie = Movie.find(posting_id)
      poll = movie.polls.create(:user_id => current_user.id, :poll_name => movie.name)
    elsif posting_type == 'Artist'
      artist = Artist.find(posting_id)
      poll = artist.polls.create(:user_id => current_user.id, :poll_name => artist.name) 
    end

    question = Question.create(:question => question, :poll_id => poll.id )
    a,*b = options.split('|')
    
    b.each_with_index do |option, index|
      Answer.create(:answer => option, :question_id => question.id)
    end

    redirect_to :back

  end

  def recently_viewed_news
    render :layout => false
  end

  def recently_viewed_posts
    render :layout => false
  end
  def index_newsurls
    @newsurl = NewsUrl.all
    render :layout => false
    
  end

  def album_scrapping
=begin
    scrap_hash = {
      "scrap_url" => params[:scrap_url],
      "posting_type" => params[:posting_type],
      "user_id" => current_user.id,
      "mention_artist_id" => params[:mention_artist_id],
      "mention_movie_id" => params[:mention_movie_id],
      "date" => params[:date]
    }
    PostsWorker.perform_async(1,3,scrap_hash)

    type = params[:posting_type]
    tmp = type.split('-')[1]
    type_string = tmp.split('_')[0]
    type_id = tmp.split('_')[1]

    posting_type = ''

    if type_string == "movie"
      album.movie_id = type_id
    elsif type_string == "artist"
      album.artist_id = type_id
    elsif type_string == "event"
      album.event_id = type_id
    end
    album.save
=end
    url = "#{params[:scrap_url]}"
    type = params[:posting_type]
    tmp = type.split('-')[1]
    type_string = tmp.split('_')[0]
    type_id = tmp.split('_')[1]
    id = params[:id]
    unless AlbumTemp.where(:url => url).present?
      album = AlbumTemp.create(
      :posting_type => params[:posting_type],
      :url => params[:scrap_url],
      :date => params[:date],
      :mention_artist_id => params[:mention_artist_id],
      :mention_movie_id => params[:mention_movie_id],
      :user_id => current_user.id,
      :done => false
      )
       if type_string == "movie"
        if NewsUrl.where(:id => id).present?
          
          NewsUrl.find(id).update_attributes(:movie_id => type_id ,:scraped => 1)

        end  
      else
        if NewsUrl.where(:id => id).present?
          
          NewsUrl.find(id).update_attributes(:artist_id => type_id ,:scraped => 1)

        end  
      end   

      render :js=>"alert('Scraping under process! will create the post soon!!');" and return
      redirect_to :back
    else
    render js: "alert('album_scrap_url already scraped');"and return 
    redirect_to :back  
    end
    
  end

  def news_scrap (news_content,title)
    #news_content = Iconv.conv('ASCII//IGNORE', 'UTF8', d.css("#body_lblArticle").text())
    news_content = news_content.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
    #puts news_content  
    title = title.last().encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")

  end

  def news_scraping_data(id,home_url,image_url,title,source_name,type,news_content,user)
    begin
        Post.scraping_news_moviesites(id,home_url,image_url,title,source_name,type,news_content,user)
        puts("successful")
        if request.xhr?
          render :json => {"success"=>true}.to_json
        end
          #render :json => {"success"=>true}.to_json
         
    rescue 
        Post.scraping_news_randomimage_sites(id,home_url,title,source_name,type,news_content,user)              
        puts("successful")
        if request.xhr?
          render :json => {"success"=>true}.to_json
        end
        #redirect_to :back 

    end
  end
    

  #scrapping news from other sites
  def news_scrapping
    params[:current_user_id] = current_user.id
    response = {"success" => true}
    begin
      Post.create_from_scrapped_url(params)
    rescue Exception => e
      Sample.news_scraping_failure(e.message).deliver!
      logger.debug("Error in creating post")
      logger.debug(e.backtrace.join('\n'))
      response['success'] = false
    end
    render :json => response.to_json
  end

  
  def album_cover_image_change
    album_id = params[:album_id]
    image_id = params[:image_id]
    post_id = params[:post_id]
    album = Album.find(album_id)
    album.cover_image_id = image_id
    album.post_id = post_id
    album.save
     redirect_to :back
  end
 
  def post_content_edit
    post_id = params[:post_id]
    @post = Post.find(post_id)
    if @post.postable_type == "News"
      @news = News.find(@post.postable_id)
    end
    #render :layout => "ckeditor"
   end
 
  def post_edit
    post = Post.find(params[:post_id])
    post.title = params[:title]
    post.save
    news = News.find(post.postable_id)
    news.content = params[:news_content] unless params[:news_content].nil?
    news.save

    if params[:image_id]
      Image.post_image_update(post,params[:image_id])
    elsif params[:image_url]
      image_url = params[:image_url]
      `wget -P public/tmp/post_images #{image_url}`
      file_name = image_url.split('/').last
      image_file = File.open(Rails.public_path.to_s + '/tmp/post_images'+ '/' + file_name)
      image = Image.create(:image => image_file)
      Image.post_image_update(post,image.id)
    end
      
    redirect_to :back
  end

  def delete_album_photo
    image_id = params[:image_id]
    AlbumImage.find_by_image_id(image_id).delete
    redirect_to :back
  end

  private

  def mention

  end

end
  
