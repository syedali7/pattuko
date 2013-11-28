class Product < ActiveRecord::Base
	attr_accessible :title, :brand, :price, :offer_note, :image, :style_id, :product_url, :size, :store
	belongs_to :style
	mount_uploader :image, ImageUploader
end
