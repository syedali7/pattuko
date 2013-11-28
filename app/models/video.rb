class Video < ActiveRecord::Base
  attr_accessible :youtube_url, :youtube_code, :video_type
  has_many :posts, as: :postable
  belongs_to :artist
  belongs_to :movie

  after_create :upload_video_image

  def upload_video_image
	require 'fog'
  	id = self.id
  	image_url = youtube_code
  	i = Magick::Image::read(image_url).first
    face = i.crop!(125, 0, 224, 360)
    face.write(Rails.public_path.to_s + "/uploads/tmp/#{id}.jpg")
  	con = Fog::Storage.new({
                 :provider                 => 'AWS',
                 :aws_secret_access_key    => 'DFpTn15jvRdi4Gus3D22tDXl1ixfOZIikEyxoeqi',
                 :aws_access_key_id        => 'AKIAJUJWBWRZ7T4NY4IA'
  	      })
  	puts("this is for testing")

    if Rails.env == 'production'
      bucket = con.directories.get('famru_prod')
    elsif Rails.env == 'development'
      bucket = con.directories.get('famru_testing')
    end

    t = Time.now + (12*30*24*60*60)

  	bucket.files.create(:key => "video_images/#{id}.jpg", 
  		:body => File.open(Rails.public_path.to_s + "/uploads/tmp/#{id}.jpg"), 
      :expires => t.strftime("%a, %d %b %Y %H:%M:%S GMT"),
      :public => true)

    if Rails.env == 'production'
      self.youtube_code = "http://d2tgu4jwper4r3.cloudfront.net/video_images/#{id}.jpg"
    elsif Rails.env == 'development'
      self.youtube_code = "http://d154rvuufl6jl1.cloudfront.net/video_images/#{id}.jpg"
    end

  	self.save!

    end	

end
