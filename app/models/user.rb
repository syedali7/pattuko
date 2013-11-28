class User < ActiveRecord::Base
  
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable,  :omniauth_providers => [:facebook]

  attr_accessible :email, :password, :password_confirmation, :remember_me, 
    :username, :provider, :uid, :image_url, :profile_url, :oauth_token, :oauth_expires_at, :last_log_in_at, :score
  has_many :comments
  has_many :posts
  has_many :fans
  has_many :friends
  has_many :notifications
  has_many :discussions,:foreign_key=>:created_user
  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]

  validates_presence_of :username
  validates_uniqueness_of :username

  after_create :upload_profile_image #, :post_to_facebook

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      image_url =  auth.info.image
      s1 ,s2 = image_url. split("graph.")
      s3 =  s2.split("/picture")[0]
      profile_url = s1 + s3
      logger.debug(auth)
      unless auth.info.email.nil?
        user = User.create(username:auth.extra.raw_info.name,
                          provider:auth.provider,
                          uid:auth.uid,
                          oauth_token: auth.credentials.token,
                          oauth_expires_at: auth.credentials.expires_at,
                          email:auth.info.email,
                          password:Devise.friendly_token[0,20],
                          profile_url: profile_url,
                          image_url: auth.info.image
        )
      else
        user = User.create(username:auth.extra.raw_info.name,
                          provider:auth.provider,
                          uid:auth.uid,
                          oauth_token: auth.credentials.token,
                          oauth_expires_at: auth.credentials.expires_at,
                          password:Devise.friendly_token[0,20],
                          profile_url: profile_url,
                          image_url: auth.info.image
        )
        
      end
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def upload_profile_image
      `wget -P public/users/tmp/#{self.uid} #{self.image_url}`
      image_name = self.image_url.split('/').last
      file_obj = File.new(Rails.public_path.to_s + '/users/tmp/'+ self.uid.to_s + '/' + image_name)
      File.rename(file_obj, Rails.public_path.to_s + '/users/tmp/' + self.uid.to_s + '/' + self.id.to_s + '.jpg')
      require 'fog'
      con = Fog::Storage.new({
                   :provider                 => 'AWS',
                   :aws_access_key_id        => 'AKIAJUJWBWRZ7T4NY4IA',
                   :aws_secret_access_key    => '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'})   

      if Rails.env == 'production'
        bucket = con.directories.get('famru_prod')
      elsif Rails.env == 'development'
        bucket = con.directories.get('famru_testing')
      end
      bucket.files.create(:key => "facebook_profile_image/#{self.uid}/#{self.id}.jpg", 
        :body => File.open(Rails.public_path.to_s + "/users/tmp/#{self.uid}/#{self.id}.jpg"), :public => true)

      if Rails.env == 'production'
        self.image_url = "http://d2tgu4jwper4r3.cloudfront.net/facebook_profile_image/#{self.uid}/#{self.id}.jpg"
      elsif Rails.env == 'development'
        self.image_url = "http://d154rvuufl6jl1.cloudfront.net/facebook_profile_image/#{self.uid}/#{self.id}.jpg"
      end

      self.save!
  end 

  def post_to_facebook
    user = FbGraph::User.me(self.oauth_token)
    user.feed!(:message => 'Just joined in cinema playground', 
              :picture => 'https://si0.twimg.com/profile_images/1088818643/Samantha-57th-idea-filmfare-south-awards-2009-samanthaonline.in__8_.jpg', 
              :link => 'http://www.pattuko.com/', 
              :name => 'Cinema playground', 
              :description => 'South indian cinema portal')
  end

  def user_image_url
    image_url
  end

  def role
    if AdminUser.find_by_email(self.email).present?
      "admin" 
    else
      "non_admin"
    end
  end

end
