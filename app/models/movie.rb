class Movie < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  after_touch() { tire.update_index }
  self.include_root_in_json = false

  extend TireHelper
  include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessible :name, :release_date, :year, :image_id ,
   :wood_id ,:wiki_url , :movie_image, :edited, :slug ,:score ,:realesed_at ,
   :tendtorealesed_at

  default_scope where(:wood_id => 1)
  has_many :ratings
  has_many :movie_artists
  
  has_many :artists, :through => :movie_artists

  has_many :artist_types, :through => :movie_artists

  has_many :images, :as => :postable

  has_many :posts, :as => :posting

  has_many :watches, as: :watchable

  has_many :fans, as: :fan

  has_many :events, as: :eventable , :dependent => :delete_all

  belongs_to :wood

  has_many :related_movies

  has_many :reviews

  has_many :polls, as: :polling , :dependent => :delete_all

  has_many :mentions, as: :mentionable , :dependent => :delete_all

  has_many :discussion_taggings,:as =>:tagable

  has_many :discussions,:through => :discussion_taggings

  mount_uploader :movie_image, MovieImageUploader
  
  accepts_nested_attributes_for :artist_types

  accepts_nested_attributes_for :movie_artists

  self.includes(:artist_types)
  self.includes(:artists)
  self.includes(:movie_artists)

  mapping do
    indexes :id, :index => :not_analyzed
    indexes :name, :analyzer => 'snowball'
    indexes :total_views, :index => :not_analyzed
    indexes :fans_count, :index => :not_analyzed
    indexes :image_url_medium, :index => :not_analyzed

    indexes :artists do
      indexes :id
      indexes :name
    end

    indexes :fans do
      indexes :user_id
    end

  end

  # Define the JSON serialization
  #
  def to_indexed_json
    to_json( 
      methods: [:image_url_medium,:thumb_movie_image_present],
      include: { 
        fans: {only: [:user_id]},
        artists: {only: [:id, :name]}
      } 
    )
  end

  def thumb_movie_image_present
    if movie_image.blank? or movie_image.nil?
      0
    else
      1
    end
  end

  def should_generate_new_friendly_id?
    new_record? || slug.blank?
  end

  def image_url_medium
    self.movie_image.url(:medium)
  end

  def image
    movie_image
  end

  def hero 
    artist_type = artist_types.where(:name => 'Hero').first
    unless artist_type.nil?
      movie_artist = movie_artists.where(:artist_type_id => artist_type.id).first
      unless movie_artist.nil?
        artist = Artist.find(movie_artist.artist_id) rescue nil
      end
    end
  end

  def heroine
    artist_type = artist_types.where(:name => 'Heroine').first
    unless artist_type.nil?
      movie_artist = movie_artists.where(:artist_type_id => artist_type.id).first
      unless movie_artist.nil?
        artist = Artist.find(movie_artist.artist_id) rescue nil
      end
    end
  end

  def director
    artist_type = artist_types.where(:name => 'Directed by').first
    unless artist_type.nil?
      movie_artist = movie_artists.where(:artist_type_id => artist_type.id).first
      unless movie_artist.nil?
        artist = Artist.find(movie_artist.artist_id) rescue nil
      end
    end
  end

  def music_director
    artist_type = artist_types.where(:name => 'Original Music by').first
    unless artist_type.nil?
      movie_artist = movie_artists.where(:artist_type_id => artist_type.id).first
      unless movie_artist.nil?
        artist = Artist.find(movie_artist.artist_id) rescue nil 
      end
    end
  end

  def producer
    artist_type = artist_types.where(:name => 'Produced by').first
    unless artist_type.nil?
      movie_artist = movie_artists.where(:artist_type_id => artist_type.id).first
      unless movie_artist.nil?
        artist = Artist.find(movie_artist.artist_id) rescue nil
      end
    end
  end

  def comedian
    artist_type = artist_types.where(:name => 'comedian').first
    unless artist_type.nil?
      movie_artist = movie_artists.where(:artist_type_id => artist_type.id).first
      unless movie_artist.nil?
        artist = Artist.find(movie_artist.artist_id) rescue nil 
      end
    end
  end

  def villian
    artist_type = artist_types.where(:name => 'villian').first
    unless artist_type.nil?
      movie_artist = movie_artists.where(:artist_type_id => artist_type.id).first
      unless movie_artist.nil?
        artist = Artist.find(movie_artist.artist_id) rescue nil
      end
    end
  end
  def cast
    artist_type = artist_types.where(:name => 'Cast & Crew').first
    unless artist_type.nil?
      movie_artist = movie_artists.where(:artist_type_id => artist_type.id)
        unless movie_artist.nil?
        artist = movie_artist.collect{ |h| Artist.find(h.artist_id) rescue nil}
      end
    end
  end

  def self.casted_movies
    arr = []
    Movie.where('year >= ?', 2005).each do |m|
      if m.hero.nil? || m.heroine.nil? || m.director.nil? || m.music_director.nil?
        arr << m
      end
    end
    return arr
  end
  def movie_heros
   
  end  

  def self.cast_involved(movie)
    movie_artist = movie.artists
    cast = []
    hero = movie.hero
    heroine = movie.heroine 
    director = movie.director
    music_director = movie.music_director
    producer = movie.producer
    unless movie_artist.empty?
      movie_artist.each do |ma|
        if hero != nil && heroine != nil && director != nil && music_director != nil && producer != nil
          if (ma.id == hero.id || ma.id == heroine.id || ma.id == director.id || ma.id == music_director.id || ma.id == producer.id ) 
            cast << ma
          end
        end
      end
      cast = cast.uniq
    end
    return cast
  end

  def fans_count
    self.fans.count
  end

  def artist_image
    movie_artist = MovieArtist.where(:movie_id => self.id).order("artist_score ASC").last
    unless movie_artist.nil?
      return movie_artist.artist.profile_image
    end
  end
  def self.famus_movies(artists)
    artist_movies = MovieArtist.where(:artist_id => artists).order("id ASC")
    unless artist_movies.nil?
      movie_score = Array.new
      for i in 0...artist_movies.count
        begin
          movie_score << Movie.find(artist_movies[i]).first.score
         rescue Exception => e
           next
         end         
      end
      return movie_score
    end
      
  end

  def top_artists
    @top_artist= ["Hero","Heroine","Directed by","Original Music by","Produced by"]
    artist = Array.new
    (0...@top_artist.count).each do |i|
      artist_type = artist_types.where(:name => @top_artist[i]).first
      unless artist_type.nil?
        movie_artist = movie_artists.where(:artist_type_id => artist_type.id)
        unless movie_artist.nil?
          artist << movie_artist.collect{ |h| Artist.find(h.artist_id) rescue nil}
        end
      end
    end 
    return artist 
  end  
  scope :edited, where(:edited => 1)
end
