class Image < ActiveRecord::Base
  attr_accessible :image
  has_many :albums, :through => :album_images
  has_many :album_images
  has_many :comments, as: :commentable
  mount_uploader :image, ImageUploader

  has_many :movies

  after_create :set_image_height

  def set_image_height
    	self.thumb_height = Magick::Image::read(Rails.public_path.to_s + URI.parse(self.image.url(:thumb)).path).first.rows
      self.medium_height = Magick::Image::read(Rails.public_path.to_s + URI.parse(self.image.url(:medium)).path).first.rows
    	save!
  end

  def self.post_image_update(post,image_id)
    if post.postable_type == "News"
      news = News.find(post.postable_id)
      news.image_id = image_id 
      news.save
    elsif post.postable_type == "image"
      post.postable_id = image_id
      post.save
    end
  end


  after_touch() { tire.update_index }

  self.include_root_in_json = false

  extend TireHelper
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # we dont need mapping because we dont have any indexed columns
  mapping do

    indexes :movies do
      indexes :id, :index => :not_analyzed
      indexes :name, :index => :not_analyzed
    end

    indexes :artists do
      indexes :id, :index => :not_analyzed
      indexes :name, :index => :not_analyzed
    end
  end

  def to_indexed_json
    #d = self.as_json
    #d[:movies] = movies.map{ |m| m.name }
    #d.to_json
    to_json(
      include: { 
        movies: {only: [:id, :name]},
        artists: {only: [:id, :name]}
      } 
    )
  end

  def movies
    movies = Movie.where(:id => Post.where(:posting_type => 'Movie', :postable_type => 'News', :postable_id => News.where(:image_id => self.id)).collect(&:posting_id))
    #image = Movie.where(:id => Post.where(:posting_type => 'Movie', :postable_type => 'Image', :postable_id => Image.where(:id => self.id)).collect(&:posting_id))
    #album_image = Movie.where(:id => Post.where(:posting_type => 'Movie', :postable_type => 'Album', :postable_id => AlbumImage.where(:image_id => self.id)).collect(&:posting_id))
    #result =  news + image + album_image
    #return result.to_a
  end

  def artists
    news = Artist.where(:id => Post.where(:posting_type => 'Artist', :postable_type => 'News', :postable_id => News.where(:image_id => self.id)).collect(&:posting_id))
    #image = Artist.where(:id => Post.where(:posting_type => 'Artist', :postable_type => 'Image', :postable_id => Image.where(:id => self.id)).collect(&:posting_id))
    #album_image = Artist.where(:id => Post.where(:posting_type => 'Artist', :postable_type => 'Album', :postable_id => AlbumImage.where(:image_id => self.id)).collect(&:posting_id))
    #result =  news + image + album_image
    #return result.to_a
  end

  def artist_id
  end

  def artist_name
  end

  def event_id
  end

  def event_name
  end

  def self.upload_image(image_url)
    `wget -P public/tmp/album_post_images "#{image_url}"`
    file_name = image_url.split('/').last
    image = File.open(Rails.public_path.to_s + '/tmp/album_post_images'+ '/' + file_name)
    return Image.create!(:image => image).id
  end

  def self.get_random_image(posting_type, posting_id)
    if posting_type == "movie"

      #begin
        album_id = Movie.find(posting_id).posts.where("postable_type=?","Album").pluck(:postable_id).sample(1)
        image = Album.find(album_id[0]).images.pluck(:id).sample(1)
      #rescue 
        #image = Movie.find(posting_id).posts.where("postable_type=?","Image").pluck(:postable_id).sample(1)
      #end

    else

      begin
        album_id = Movie.find(posting_id).posts.where("postable_type=?","Album").pluck(:postable_id).sample(1)
        image = Album.find(album_id).images.pluck(:id).sample(1)
      rescue 
         image = Movie.find(posting_id).posts.where("postable_type=?","Image").pluck(:postable_id).sample(1)
      end
    end 
    return image[0] 
  end
end
