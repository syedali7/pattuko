class Post < ActiveRecord::Base
  attr_accessible :description, :title, :type, :postable_id, :postable_type, 
    :posting_type, :posting_id,:user_id, :tag_list,:trusted, :slug ,
    :post_to_facebook, :verified, :movies, :artists,:scrap_url, :created_at, :image_thumb_height
  acts_as_taggable

  belongs_to :postable, :polymorphic => true
  belongs_to :posting, :polymorphic => true

  validates :title, :presence => true
  validates :posting_type, :presence => true
  validates :posting_id, :presence => true
  has_many :comments, as: :commentable , :dependent => :delete_all
  has_many :favourites, as: :favourable , :dependent => :delete_all
  has_many :claps, as: :clap , :dependent => :delete_all
  has_many :watches, as: :watchable , :dependent => :delete_all
  has_many :albums, :dependent => :delete_all

  belongs_to :user

  default_scope order('posts.created_at DESC')

  if Rails.env == 'production'
    after_create :send_email 
  end

  #after_create :set_created_date

  def send_email
    unless AdminUser.find_by_email(User.find(self.user_id).email)
      Sample.post_created(self.id,self.user_id).deliver
    end
  end
   
  extend FriendlyId
  friendly_id :generate_friendly_url, use: [:slugged, :history]
  
  def generate_friendly_url
    obj = posting_type == "Movie" ? Movie.find(posting_id) : Artist.find(posting_id)
    return "#{title}".downcase
  end

  
  has_many :related_posts,  :dependent => :delete_all

  after_touch() { tire.update_index }

  self.include_root_in_json = false

  extend TireHelper
  include Tire::Model::Search
  include Tire::Model::Callbacks

	mapping do
    indexes :id, :index => :not_analyzed
    indexes :title, :analyzer => "snowball"
    indexes :postable_type, :index => :not_analyzed
    indexes :postable_id, :index => :not_analyzed
    indexes :posting_type, :index => :not_analyzed
    indexes :posting_id, :index => :not_analyzed
    indexes :claps_count, :index => :not_analyzed
    indexes :comments_count, :index => :not_analyzed
    indexes :total_views, :index => :not_analyzed
    indexes :image_url_thumb, :index => :not_analyzed
    indexes :image_id, :index => :not_analyzed

    indexes :claps do
      indexes :user_id
    end

    indexes :user do
      indexes :id, :index => :not_analyzed
      indexes :username, :index => :not_analyzed
      indexes :image_url, :index => :not_analyzed
    end

    indexes :comments do
      indexes :id, :index => :not_analyzed
      indexes :body, :analyzer => 'snowball'
      indexes :username, :as => 'user_name'
      indexes :user_image_url, :index => :not_analyzed
    end

    indexes :created_at, :type => 'date'

    indexes :image_thumb_height, :index => :not_analyzed

    indexes :movie, :analyzer=> 'keyword'
    indexes :artist, :analyzer => 'keyword'
  end


  def self.test
    Post.tire.search do
      query do
        boolean do
          should   { string 'movie:magadheera' }
        end
      end

      sort { by :id => 'desc' }

      # build the facets
      facet 'movies' do
        terms :movie
      end

      facet 'artists' do
        terms :artist
      end

      facet 'Type' do
        terms :postable_type
      end
    end
  end

	# Define the JSON serialization
  #
  def to_indexed_json
    to_json( methods: [:image_url_thumb, :image_thumb_height, :clapped_user_ids, :movie, :artist, :es_show_path, :image_id], 
      include: { 
        claps: {only: [:user_id]}, user: {only: [:name, :image_url]}, 
        comments: { only: [:body, :user_name, :user_image_url] },
        user: {only: [:id, :username, :image_url]}
      } 
    )
  end

  def es_show_path
    begin
      if "Movie" == self.posting_type
        "/movies/" + Movie.find(self.posting_id).slug  + "/" + self.slug
      elsif "Artist" == self.posting_type 
        "/artists/" + Artist.find(self.posting_id).slug  + "/" + self.slug
      elsif "Event" == self.posting_type
        event = Event.find(self.posting_id)
        if "Movie" == event.eventable_type
          "/movies/" + Movie.find(event.eventable_id).slug  + "/" + self.slug
        elsif "Artist" == event.eventable_type
          "/artists/" + Artist.find(event.eventable_id).slug  + "/" + self.slug
        elsif event.eventable_type.nil?
          "/events/" + event.slug + "/" + self.slug
        end
      else
        "/posts/" + self.id.to_s
      end
    rescue
      "/posts/" + self.id.to_s
    end
  end

  def clapped_user_ids
  	self.claps.map(&:user_id)
	end

  def image_url_thumb
  	self.postable_type == "Video" ? Video.find(self.postable_id).youtube_code : self.image.url(:thumb)
  	#"http://d154rvuufl6jl1.cloudfront.net/video_images/5.jpg"
 	end

  def image_id
    self.postable_type == "Video" ? nil : self.image_id
    #"http://d154rvuufl6jl1.cloudfront.net/video_images/5.jpg"
  end

  def user_image_url
    
  end

 	def image_thumb_height
 		if self.postable_type == "Video"
 			return 360
		else
			if self.postable_type == "News"
				return Image.find(News.find(self.postable_id).image_id).thumb_height
			elsif self.postable_type == "Album"
				return Image.find(Album.find(self.postable_id).cover_image_id).thumb_height
			elsif self.postable_type == "Image"
				return Image.find(self.postable_id).thumb_height
			end
		end	
		return 360
	end

	def movie
		self.posting_type == "Movie" ? Movie.find(self.posting_id).name : ""
	end

	def artist
		self.posting_type == "Artist" ? Artist.find(self.posting_id).name : ""
	end

  def post_artist
    if self.posting_type == "Artist"
      Artist.find(self.posting_id)
    elsif self.posting_type == "Movie"
      Movie.find(self.posting_id).hero
    end
  end

  def feed
    user_ids = []
    if (posting_type == "Movie")
      movie_id = Movie.find(posting_id).id
      user_ids = Fan.where(:fan_id => movie_id).map(&:user_id)
      artist_ids = []
      ma = Movie.find(movie_id).artists
      ma.each do |a|
        artist_ids << a.id
      end
      artist_ids = artist_ids.uniq
      artist_ids.each do |a|
        artist_type_id = MovieArtist.where(:artist_id => a).map(&:artist_type_id).first
        hero = ArtistType.find_by_name("Hero")
        director = ArtistType.find_by_name("Directed by")
        if (artist_type_id == hero.id || artist_type_id == director.id)
          user_ids = user_ids + Fan.where(:fan_id => a).map(&:user_id)
        end
      end
    elsif (posting_type == "Artist")
      artist_id = Artist.find(posting_id).id
      user_ids = Fan.where(:fan_id => artist_id).map(&:user_id)
    end
    user_ids = user_ids.uniq
    user_ids.each do |user_id|
      feed = Feed.where(:user_id => user_id , :post_id => id).first
      if feed.nil?
        feed = Feed.create(:user_id => user_id , :post_id => id, :post_created_on => created_at )
      end
    end
  end

  def self.fan_follow_feed(posts,user_id)
    posts.each do |p|
      post_feed = Feed.where(:post_id => p.id, :user_id => user_id).first
      if post_feed.nil?
        feed = Feed.create(:user_id => user_id , :post_id => p.id, :post_created_on => p.created_at )
      end
    end
  end

  def people_involved
    if posting_type == "Movie"
      movie_id = posting_id
      movie = Movie.find(movie_id)
      movie_artist = Movie.find(movie_id).artists
      people = []
      hero = movie.hero
      heroine = movie.heroine 
      director = movie.director
      music_director = movie.music_director
      producer = movie.producer
      unless movie_artist.empty?
        movie_artist.each do |ma|
          if hero != nil && heroine != nil && director != nil && music_director != nil && producer != nil
            if (ma.id == hero.id || ma.id == heroine.id || ma.id == director.id || ma.id == music_director.id || ma.id == producer.id ) 
              people << ma
            end
          end
        end
        people = people.uniq
      end

    elsif posting_type == "Artist"
      artist_id = posting_id
      artist_movie = Artist.find(artist_id).movies
      people = artist_movie.uniq
      artist_movie_ids = []
      artist_movie.each do |am|
        artist_movie_ids << am.id
      end
      artist_movie_ids  = artist_movie_ids.uniq

    elsif posting_type == "Event"

      event = Event.find(posting_id)
      if event.eventable_type == "Movie"
        movie_id = event.eventable_id
        movie = Movie.find(movie_id)
        movie_artist = Movie.find(movie_id).artists
        people = []
        hero = movie.hero
        heroine = movie.heroine 
        director = movie.director
        music_director = movie.music_director
        producer = movie.producer
        unless movie_artist.empty?
          movie_artist.each do |ma|
            if hero != nil && heroine != nil && director != nil && music_director != nil && producer != nil
              if (ma.id == hero.id || ma.id == heroine.id || ma.id == director.id || ma.id == music_director.id || ma.id == producer.id ) 
                people << ma
              end
            end
          end
          people = people.uniq
        end
      elsif event.eventable_type == "Artist"
        artist_id = event.eventable_id
        artist_movie = Artist.find(artist_id).movies
        people = artist_movie.uniq
        artist_movie_ids = []
        artist_movie.each do |am|
          artist_movie_ids << am.id
        end
        artist_movie_ids  = artist_movie_ids.uniq
      end
    elsif event.eventable_type.nil?
      people = []
    end
    return people
  end


  def links
    # get the previous post and the next post in the grid
    # TODO this has to be more dynamic depends on the url of the post
    # can be achived based on the HTTP_REFERRER header from the request
    return { :next => Post.find(:first, :conditions => ["id < ?", self.id]), :prev => Post.find(:first, :conditions => ["id > ?", self.id], :order => 'id asc') }
=begin    
    if posting_type == "Movie"
      movie_id = posting_id
      links = Post.where(:posting_type => "Movie", :posting_id => movie_id, :postable_type => "News")
    elsif (posting_type == "Artist")
      artist_id = posting_id
      links = Post.where(:posting_type => "Artist", :posting_id => artist_id, :postable_type => "News")
    elsif posting_type == "Event"
      event = Event.find(posting_id)
      if event.eventable_type == "Movie"
        movie_id = event.eventable_id
        links = Post.where(:posting_type => "Movie", :posting_id => movie_id, :postable_type => "News")
      elsif event.eventable_type == "Artist"
        artist_id = event.eventable_id
        links = Post.where(:posting_type => "Artist", :posting_id => artist_id, :postable_type => "News")
      elsif event.eventable_type.nil?
        links = Post.where(:posting_type => "Event", :posting_id => event.id, :postable_type => "News")
      end
    end
    return links
=end
  end

  def keywords
    keys = []
    if posting_type == 'Movie'
         movie = Movie.find(posting_id)
         unless movie.nil?
           keys << movie.name 
           keys << movie.hero.name unless movie.hero.nil?
           keys << movie.heroine.name unless movie.heroine.nil?
           keys << movie.director.name unless movie.director.nil?
           keys << movie.music_director.name unless movie.music_director.nil?
           keys << movie.producer.name unless movie.producer.nil?
        end
    elsif posting_type == 'Artist'
      artist = Artist.find(posting_id)
       keys << artist.name unless artist.nil?
    end
    return keys.join(',')
  end

  def image
    if postable_type == "News"
      news = News.find(postable_id)
      image = Image.find(news.image_id)
      image.image
    elsif postable_type == "Image"
      image = Image.find(postable_id)
      image.image
    elsif postable_type == "Album"
      album = Album.find(postable_id)
      image = Image.find(album.cover_image_id)
      image.image
    elsif postable_type == "Video"
      video = Video.find(postable_id)
      video.youtube_code
    end
  end  

  def posting_name
    if posting_type == "Movie"
      movie = Movie.find(posting_id)
      movie.name
    elsif posting_type == "Artist"
      artist = Artist.find(posting_id)
      artist.name
    elsif posting_type == "Event"
      event = Event.find(posting_id)
      if event.eventable_type == "Movie"
        movie = Movie.find(posting_id)
        movie.name
      elsif event.eventable_type == "Artist"
        artist = Artist.find(posting_id)
        artist.name
      end
    end
  end

  def posting_fans
    if posting_type == "Movie"
      movie = Movie.find(posting_id)
      movie.fans
    elsif posting_type == "Artist"
      artist = Artist.find(posting_id)
      artist.fans
    elsif posting_type == "Event"
      event = Event.find(posting_id)
      if event.eventable_type == "Movie"
        movie = Movie.find(posting_id)
        movie.fans
      elsif event.eventable_type == "Artist"
        artist = Artist.find(posting_id)
        artist.fans
      end
    end
  end

  def image_id
    if postable_type == "News"
      news = News.find(postable_id)
      image = Image.find(news.image_id)
      image.id
    elsif postable_type == "Image"
      image = Image.find(postable_id)
      image.id
    elsif postable_type == "Album"
      album = Album.find(postable_id)
      image = Image.find(album.cover_image_id)
      image.id
    elsif postable_type == "Video"
      video = Video.find(postable_id)
      video.youtube_code
    end
  end

  def self.fan_follow_movie_via_post(user_id, posting_type, posting_id)
    movie_id = Movie.find(posting_id).id
    fan = Fan.where(:fan_id => movie_id, :fan_type => 'Movie', :user_id => user_id).first
    if fan.nil?
      movie = Movie.find(movie_id)
      movie.fans.create(:user_id => user_id)
      posts = Post.where(:posting_type => "Movie", :posting_id => movie_id)
      posts = posts.uniq

      #user score
      action_score = Score.create(:user_id => user_id, :score => 10, 
        :action => "Fan || Movie || #{movie.name} || id[#{movie.id}]")
      total_score = action_score.score
      user = User.find(user_id)
      user.score += total_score
      user.save


      Post.fan_follow_feed(posts,user_id)
    end
  end

  def self.fan_follow_artist_via_post(user_id, posting_type, posting_id)
    artist_id = Artist.find(posting_id).id
    fan = Fan.where(:fan_id => artist_id, :fan_type => 'Artist', :user_id => user_id).first
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
      action_score = Score.create(:user_id => user_id, :score => 10, 
        :action => "Fan || Artist || #{artist.name} || id[#{artist.id}]")
      total_score = action_score.score
      user = User.find(user_id)
      user.score += total_score
      user.save

      Post.fan_follow_feed(posts,user_id)
    end
  end

  def self.mention(post,mention_artist_id,mention_movie_id)
    artist_men_ids = []
    artist_men_ids = mention_artist_id.split(",")
    artist_men_ids.delete('')

    unless artist_men_ids.empty?
      artist_men_ids.each do |a|
        Artist.find(a).mentions.create(:post_id => post.id)
      end
    end
    movie_men_ids = []
    movie_men_ids = mention_movie_id.split(",")
    movie_men_ids.delete('')

    unless movie_men_ids.empty?
      movie_men_ids.each do |m|
        Movie.find(m).mentions.create(:post_id => post.id)
      end
    end
  end

  def self.news_post_to_facebook(post,text,news,user)
    go = GoShortener.new("AIzaSyCEgJ2_Xea3zavgGMKkx_Dx1feZaLlnNGM")
    post_url = go.shorten "http://www.pattuko.com" + post.es_show_path
    caption = post.posting_name.to_s + "   " +  post.posting_fans.count.to_s + " " +"fans"
      @user = Koala::Facebook::GraphAPI.new(user.oauth_token)
      @user.put_wall_post("#{text}", {
      "name" => "#{post.title}",
      "link" => "#{post_url}",
      "caption" => "#{caption}",
      "description" => "#{news.content}",
      "picture" => "#{post.image}"
      })
  end

  def self.image_post_to_facebook(post,text,user)
    go = GoShortener.new("AIzaSyCEgJ2_Xea3zavgGMKkx_Dx1feZaLlnNGM")
    post_url = go.shorten "http://www.pattuko.com" + post.es_show_path
    @user_graph = Koala::Facebook::API.new(user.oauth_token)
    @user_graph.put_picture("#{post.image}",
    {:message => "#{text}  #{post_url}" })  

  end



  def self.scraping_news_moviesites(id,home_url,image_url,title,sourse_name,type,news_content,user)
    image_file_name = title1.gsub(" ", "_") + ".jpg"
    `wget -O public/uploads/tmp/news_post_images/#{image_file_name} "#{image_url}"`
    image = File.open(Rails.public_path.to_s + '/uploads/tmp/news_post_images'+ '/' + image_file_name)
    post_image = Image.create!(:image => image)
    puts post_image.id
    type = type
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
            
    news = News.create(:scrap_url => home_url ,:content => news_content, :image_id => post_image.id, :source_name => sourse_name)
    post = Post.create!(:scrap_url => home_url,:title => title , :posting_id => type_id,
         :posting_type => posting_type, :postable_type => 'News', :postable_id => news.id , 
          :user_id => user, :post_to_facebook => 0 )
    if type_string == "movie"
      if NewsUrl.where(:id => id).present?
        
        NewsUrl.find(id).update_attributes(:movie_id => type_id ,:scraped => 1)

      end  
    else
      if NewsUrl.where(:id => id).present?
        
        NewsUrl.find(id).update_attributes(:artist_id => type_id ,:scraped => 1)

      end  
    end  

    scrap_hash = {}
    PostsWorker.perform_async(post.id,1,scrap_hash)

    #inserting this particular post to the current user feed
    feed = Feed.create(:user_id => user ,:post_id => post.id, :post_created_on => post.created_at )
  end

  def self.create_from_scrapped_url(params)
    #logger.debug(params[:news_url_id])
    news_url = NewsUrl.find(params[:news_url_id])
    #logger.debug(news_url)
    escaped_data = news_url.update_title_content
    unless params[:image_url].empty?
      post_image = Image.upload_image(params[:image_url])
    else
      post_image = Image.get_random_image(params[:posting_type], params[:posting_id])
      #logger.debug("i am from posts controller"+post_image.to_s)
    end

    

    #if post_image.nil?
      # here we need to get the random image for the posting_type and posting_id
      #post_image = Image.get_random_image(params[:posting_type], params[:posting_id])
    #end
            
    news = News.create!(:scrap_url => news_url.news_url, :content => escaped_data[:news_content], :image_id => post_image, :source_name => news_url.source_name)
    post = Post.create!(:scrap_url => news_url.news_url, :title => escaped_data[:title] , :posting_id => params[:posting_id],
          :posting_type => params[:posting_type], :postable_type => 'News', :postable_id => news.id , 
          :user_id => params[:current_user_id], :post_to_facebook => 0)


    if params[:posting_type] == "movie"
      if news_url.present?
      news_url.update_attributes(:movie_id =>  params[:posting_id], :scraped => 1)
      end
    elsif params[:posting_type] == "artist"
      if news_url.present?
        news_url.update_attributes(:artist_id =>  params[:posting_id], :scraped => 1)
      end  
    end

    scrap_hash = {}
    PostsWorker.perform_async(post.id, 1, scrap_hash)
    PostsWorker.perform_async(post.id, 2, scrap_hash)
  end

  def self.scraping_news_randomimage_sites(id,home_url,title,sourse_name,type,news_content,user)
    type = type
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
      begin
        if posting_type == "Movie"
          images = Album.find(Movie.find(type_id).posts.where("postable_type=?","Album").first.postable_id).images 
       
            r = rand(1..images.length)
            image_id = images[r].id                
            news = News.create!(:scrap_url => home_url,:content => news_content, :image_id => image_id, :source_name => sourse_name)
            post = Post.create!(:scrap_url => home_url,:title => title , :posting_id => type_id,
             :posting_type => posting_type, :postable_type => 'News', :postable_id => news.id , 
              :user_id => user, :post_to_facebook => 0 )
        else
          images = Album.find(Artist.find(type_id).posts.where("postable_type=?","Album").first.postable_id).images 
       
            r = rand(1..images.length)
            image_id = images[r].id                
            news = News.create!(:scrap_url => home_url,:content => news_content, :image_id => image_id, :source_name => sourse_name)
            post = Post.create!(:scrap_url => home_url,:title => title , :posting_id => type_id,
             :posting_type => posting_type, :postable_type => 'News', :postable_id => news.id , 
              :user_id => user, :post_to_facebook => 0 )
        end    
         if type_string == "movie"
            if NewsUrl.where(:id => id).present?
              
              NewsUrl.find(id).update_attributes(:movie_id => type_id ,:scraped => 1)

            end  
          else
            if NewsUrl.where(:id => id).present?
              
              NewsUrl.find(id).update_attributes(:artist_id => type_id ,:scraped => 1)

            end  
          end  

          scrap_hash = {}
          PostsWorker.perform_async(post.id,1,scrap_hash)

          #inserting this particular post to the current user feed
          feed = Feed.create(:user_id => user ,:post_id => post.id, :post_created_on => post.created_at )
    rescue 
        if posting_type == "Movie"
          image = Movie.find(type_id).posts.where("postable_type=?","Image")
            r = rand(0...image.length)
            puts r
            image_id = image[r].postable_id
            
            news = News.create!(:scrap_url => home_url,:content => news_content, :image_id => image_id, :source_name => sourse_name)
            post = Post.create!(:scrap_url => home_url ,:title => title , :posting_id => type_id,
             :posting_type => posting_type, :postable_type => 'News', :postable_id => news.id , 
              :user_id => user, :post_to_facebook => 0 ) 
        else
           image = Artist.find(type_id).posts.where("postable_type=?","Image")
            r = rand(0...image.length)
            puts r
            image_id = image[r].postable_id
            
            news = News.create!(:scrap_url => home_url,:content => news_content, :image_id => image_id, :source_name => sourse_name)
            post = Post.create!(:scrap_url => home_url ,:title => title , :posting_id => type_id,
             :posting_type => posting_type, :postable_type => 'News', :postable_id => news.id , 
              :user_id => user, :post_to_facebook => 0 ) 
        end    

        if type_string == "movie"
          if NewsUrl.where(:id => id).present?
            
            NewsUrl.find(id).update_attributes(:movie_id => type_id ,:scraped => 1)

          end  
        else
          if NewsUrl.where(:id => id).present?
            
            NewsUrl.find(id).update_attributes(:artist_id => type_id ,:scraped => 1)

          end  
        end  
        scrap_hash = {}
        PostsWorker.perform_async(post.id,1,scrap_hash)

        #inserting this particular post to the current user feed
        feed = Feed.create(:user_id => user ,:post_id => post.id, :post_created_on => post.created_at )
      
    end
                             
  end

    def self.new_scraping_urls(k)
      news_url = Array.new
      for i in 0...k.length
        news_url[i] = k[i].attr("href")
        #puts news_url.count
      end
  
      news_url.each do|n|
        for k in (0...news.length) 
          if n === news[k].scrap_url
            puts "success"
            puts n
            puts k
            @news_url = ""
          else
            @news_url = n
            #Sample.news_scraping_failure(n).deliver!  
                 
          end
        end
        puts @news_url
        #Sample.news_scraping_urls(@news_url).deliver!  
      end   
      
    end
        

=begin

  def short_url
    begin
      GoShortener.new("AIzaSyCEgJ2_Xea3zavgGMKkx_Dx1feZaLlnNGM").shorten "http://www.pattuko.com" + self.es_show_path
    rescue
      return nil
    end
  end
=end

  def set_created_date
     self.created_at_date = Date.today()
     self.save!
  end

  def next_record
    begin
      Post.find(:first, :conditions => ['id < ? AND postable_type = ?', self.id, "News"]).es_show_path
    rescue
      return nil
    end
  end

  def previous_record
    begin
      Post.find(:first, :conditions => ['id < ? AND postable_type = ?', self.id, "News"]).es_show_path
    rescue
      return nil
    end
  end

  def self.cron_post_creation(album,posting_type,title,user_id,men_mov_id,men_art_id,c_date)

    mention_movie_id = men_mov_id
    mention_artist_id = men_art_id
    album.cover_image_id = album.images.first.id
    album.save!

    type = posting_type
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

    begin
      date = c_date
    rescue
      date = Time.now
    end

    post = Post.create!( :title => title , :posting_id => type_id,
         :posting_type => posting_type, :postable_type => 'Album', :postable_id => album.id , 
          :user_id => user_id, :post_to_facebook => 0, :created_at => date )

    album.post_id = post.id
    album.save

    username = User.find(user_id).username
    post_id = post.id

    Sample.album_scrap_success(post,username).deliver!

    scrap_hash = {}
    PostsWorker.perform_async(post.id,1,scrap_hash)

    #inserting this particular post to the current user feed
    feed = Feed.create(:user_id => user_id ,:post_id => post.id, :post_created_on => post.created_at )
    PostsWorker.perform_async(post.id,2,scrap_hash)

  end


  def self.image_creation(image_url,album)
    `wget -P public/tmp/album_post_images "#{image_url}"`
      file_name = image_url.split('/').last
      image = File.open(Rails.public_path.to_s + '/tmp/album_post_images'+ '/' + file_name)
      post_image = Image.create(:image => image)
      AlbumImage.create!(:album_id => album.id , :image_id => post_image.id)
  end
end
  
