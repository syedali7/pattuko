class Style < ActiveRecord::Base
	attr_accessible :title, :image, :product_url, :thumb_height, :movie_id, :artist_id, :event_id, :products_attributes
	has_many :products
	has_many :claps, as: :clap , :dependent => :delete_all

	mount_uploader :image, ImageUploader
	accepts_nested_attributes_for :products, :allow_destroy => true

	default_scope order('styles.created_at DESC')

	after_create :set_image_height

	def set_image_height
		self.thumb_height = Magick::Image::read(Rails.public_path.to_s + URI.parse(self.image.url(:thumb)).path).first.rows
	  	save!
	end

	def movie
		movie = Movie.find(movie_id)
		return movie
	end

	def artist
		artist = Artist.find(artist_id)
		return artist
	end

	def clapped_user_ids
  		self.claps.map(&:user_id)
	end

end
