class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      begin
         if AdminUser.find_by_email(@user.email)
            session[:admin]=true
         end
         rescue ActiveRecord::RecordNotFound
          session[:admin]=false
      end 
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?

      if @user.sign_in_count == 1
        begin
          @post = Post.where(:trusted => true, :postable_type => "News")
          Sample.welcome(@user.email , @user.username, @post ).deliver!
        rescue
        end

        @user.score = 10
        @user.save

        if Rails.env == 'production'
          user = FbGraph::User.fetch(@user.uid,:access_token => "571291972902708|204fc1b69e97e1f4b46a8edd2a2de2bd")
        elsif Rails.env == 'development'
          user = FbGraph::User.fetch(@user.uid,:access_token => "395353090487713|93478429753170e2c6f0390bfe7e6180")
        end

        friends = user.friends
        friend_ids = []
        friends .each do |f|
          test = f.raw_attributes
          friend_ids << test["id"]
          puts friend_ids
        end
        id = @user.uid
        users = User.all
        friend_ids.each do |friend_id|
          users.each do |u|
            if (u.uid == friend_id)
              user_friend = User.find_by_uid(friend_id)
              friend_id = user_friend.id
              Friend.create(:user_id => @user.id,:friend_id => friend_id)
              Notification.create(:user_id => @user.id, :friend_id => friend_id, 
                 :notification => "Friend added")
            end
          end
        end
      end
      session[:return_to] = request.env["HTTP_REFERER"]
      remember_me(@user)
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def sample
  end
end
