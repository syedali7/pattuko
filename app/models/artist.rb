class Artist < ActiveRecord::Base

  extend TireHelper
  include Tire::Model::Search
  include Tire::Model::Callbacks

  after_touch() { tire.update_index }
  self.include_root_in_json = false

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  
  attr_accessible :name, :artist_image, :artist_profile_image, :profession, :dob, :description

  has_many :movie_artists
  
  has_many :movies, :through => :movie_artists

  has_many :artist_types, :through => :movie_artists

  has_many :images, :as => :postable

  has_many :posts, :as => :posting

  has_many :wishes, :as => :wish

  has_many :videos

  has_many :fans, as: :fan

  has_many :watches, as: :watchable

  has_many :events, as: :eventable , :dependent => :delete_all

  has_many :polls, as: :polling , :dependent => :delete_all

  has_many :mentions, as: :mentionable , :dependent => :delete_all

  has_many :discussion_taggings,:as =>:tagable

  has_many :discussions,:through => :discussion_taggings

  has_many :relationships

  mount_uploader :artist_image, ArtistImageUploader

  mount_uploader :artist_profile_image, ArtistProfileImageUploader

  has_many :artist_professions

  self.includes(:artist_types)
  self.includes(:movies)
  self.includes(:movie_artists)

   settings :analysis => { 
     :filter => {
       :trip_ngram  => {
         "type"     => "edgeNGram",
         "max_gram" => 15,
         "min_gram" => 2 }
     },
     :analyzer => {
       :index_ngram_analyzer => {
         "type" => "custom",
         "tokenizer" => "standard",
         "filter" => [ "standard", "lowercase", "trip_ngram" ] 
       }, 
       :search_ngram_analyzer => {
         "type" => "custom",
         "tokenizer" => "standard",
         "filter" => [ "standard", "lowercase"] 
       }, 
     }     
  }

  mapping do
    indexes :id, :index => :not_analyzed
    indexes :name, :analyzer => 'snowball'
    #indexes :suggest, :type => :completion, :index_analyzer => :simple, :search_analyzer => :simple, :payloads => true
  end

  # Define the JSON serialization
  #
  def to_indexed_json
    to_json( 
      methods: [:image_url_medium, :thumb_artist_image_present]
      #:suggest => :suggest
    )
  end

  def suggest
    {
      :input => self.name.split(/\W/).reject(&:empty?), :output => self.title, 
      :payload => { :title => self.title }
    }
  end

  def thumb_artist_image_present
    if artist_image.blank? or artist_image.nil?
      0
    else
      1
    end
  end

   def image_url_medium
    self.artist_image.url(:medium)
  end

  def self.test

    Artist.tire.search(:page => 1, :per_page => 5) do
      query {all}
      #sort { by :id => 'desc' }
      sort do
      #  by :id => 'desc'
        by :id => 'desc', :thumb_artist_image_present => 'desc'
      end
    end
  end

  def self.people_involved(artist)
      artist_movie = artist.movies
      people = artist_movie.uniq
      artist_movie_ids = []
      artist_movie.each do |am|
        artist_movie_ids << am.id
      end
      artist_movie_ids  = artist_movie_ids.uniq
    return people
  end

  def type
    artist_types.first.name
  end

  def photos
    Post.where(:postable_type => "Image", :posting_type => "Artist", :posting_id => self.id)
  end

  def videos
    Post.where(:postable_type => "Video", :posting_type => "Artist", :posting_id => self.id)
  end

  def video_show_path
    "/artists/" + slug + "/" + "videos"
  end

  def photo_show_path
    "/artists/" + slug + "/" + "photos"
  end

  def post_show_path
    "/artists/" + slug + "/" + "posts"
  end

end
