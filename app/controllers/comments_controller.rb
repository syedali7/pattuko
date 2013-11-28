class CommentsController < ApplicationController
  #before_filter :load_commentable
 
  def index
    @commentable = Post.find(params[:post_id])
    @comments = @commentable.comments
  end

  def show
    @post = Post.friendly.find(params[:id])
    @commentable = @article
    @comments = @commentable.comments
    @comment = Comment.new
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    if request.xhr?
      #Post.friendly.find(params[:post_id])
      #Comment.create(:body => params[:content], :user_id => params[:user_id], :commentable_type => 'post', :commentable_id => params[:post_id])
      post_creator=User.find(Post.find(params[:post_id]).user_id)      
      Post.find(params[:post_id]).comments.create(:body => params[:content], :user_id => params[:user_id])
      Notification.create(:user_id=>post_creator.id,:friend_id=>param[:user_id],:notification=>"#{current_user.username} commented on your post",:friend_name=>current_user.username)      
      Sample.user_notification("#{current_user.username} commented on your post",post_creator.email).deliver
      redirect_to :back
    else
      @comment = @commentable.comments.new(params[:comment])
      if @comment.save
        redirect_to root_url
      end
    end
  end

  def image_comment_create
    if request.xhr?
      Image.find(params[:img_id]).comments.create(:body => params[:content], :user_id => params[:user_id])
      redirect_to :back
    end  
  end

  def comment_like
    comment_id  = params[:comment_id]
    user_id = params[:user_id]
    likes = Like.where(:user_id => user_id, :likeable_id => comment_id, :likeable_type => "Comment").first
    if likes.nil?
      Comment.find(comment_id).likes.create(:user_id => user_id)
    end
    redirect_to :back
  end

  def comment_delete
    comment_id  = params[:comment_id]
    Comment.find(comment_id).delete
    redirect_to :back
  end


  private

    #def load_commentable
      #resource,id = request.path.split('/')[1,2]
      #@commentable = resource.singularize.classify.constantize.find(id)
    #end

end