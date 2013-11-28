# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  include CarrierWave::Processing::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  include CarrierWave::MimeTypes
  process :set_content_type

  process :strip # strip image of all profiles and comments
  process :quality => 90 # Set JPEG/MIFF/PNG compression level (0-100)
  #process :colorspace => :rgb # Set colorspace to rgb or cmyk

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
     "uploads/posts/#{model.class.to_s.underscore}/#{model.id}"
  end

  version :thumb do
    process :resize_to_fit => [224, 1000000]
  end

  version :trend do
    process :resize_to_fit => [106, 0]
  end

  version :medium do
    process :resize_to_limit => [550, 500]
  end

  def default_url
      self.asset_host + "/images/fallback/movie/" + [version_name, "default.jpg"].compact.join('_')
      #{}"fallback/movie/thumb_default.jpg"
  end

  #version :tiny do
    #process :resize_to_limit => [48, 63]
  #end

  #version :small do
    #process :resize_to_limit => [96, 126]
  #end

  #version :large do
    #process :resize_to_limit => [480, 630]
  #end

  version :little do
    process :resize_to_fit => [31, 10000000]
  end

  #version :medium do
    #process :resize_to_limit => [290, 390]
  #end

  #version :original do
    #process :resize_to_limit => [480, 630]
  #end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end