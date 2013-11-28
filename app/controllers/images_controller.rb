class ImagesController < ApplicationController

  def index
    @images = Image.all
  end

  def show
    @image  = Image.find(params[:id])
  end


  def new
   @image = @postable.images.new
  end

  def create
    if @post.nil?
        @image = Image.create(params[:image])
    else
        @image = @post.images.create(params[:image])
    end
    respond_to do |format|
        format.js
    end
  end

  def load_image_comments
   @comments = Image.find(params[:image_id]).comments
   @image = Image.find(params[:image_id])
   render :layout => false
  end

  #to create album by selecting in the images in the view and show the preview
  def images_select_album_create_render
    @images_ids = []
    images_ids = params[:image_ids]
    images_ids.each do |image_id|
      if image_id[-1] == "&"
        image_id[-1]=""
      end
      @images_ids << image_id
    end
  end

  #to create album by selecting in the images in the view and show the preview
  def images_select_album_create
    title = params[:title]
    album_name = params[:album_name]
    movie_id = params[:edit_movie_id]
    artist_id = params[:edit_artist_id]
    event_id = params[:edit_event_id]
    user_id = current_user.id

    album = Album.create(:album_name => album_name)
    images_ids = params[:images_ids]
    post_to_facebook = params[:post_fb]
    images_ids.split(" ").each do |image_id|
       AlbumImage.create(:album_id => album.id, :image_id => image_id)
    end

    album.cover_image_id = images_ids.split(" ")[0]
    album.save

    post_created = false

    if !movie_id.empty? && !post_created
      post = Post.create( :title => title , :posting_id => movie_id, 
      :posting_type => "Movie" , :postable_type => 'Album',
      :postable_id => album.id, :user_id => current_user.id)
      post_created = true
    end

    if !artist_id.empty? && !post_created
      post = Post.create( :title => title , :posting_id => artist_id, 
      :posting_type => "Artist" , :postable_type => 'Album',
      :postable_id => album.id, :user_id => current_user.id)
      post_created = true
    end

    if !event_id.empty? && !post_created
      post = Post.create( :title => title , :posting_id => event_id, 
      :posting_type => "Event" , :postable_type => 'Album',
      :postable_id => album.id, :user_id => current_user.id)
    end
    Post.mention(post,params[:mention_artist_id],params[:mention_movie_id])

    #inserting this particular post to the current user feed
    feed = Feed.create(:user_id => user_id ,:post_id => post.id, :post_created_on => post.created_at )

    #user score
    action_score = Score.create(:user_id => current_user.id, :score => 20, :action => "Post created || Album || post id is #{post.id}")
    total_score = action_score.score
    current_user.score += total_score
    current_user.save

    scrap_hash = {}

    PostsWorker.perform_async(post.id,1,scrap_hash)
    PostsWorker.perform_async(post.id,2,scrap_hash)
    redirect_to root_url

  end

  def discussions
    @image=Image.create(params[:image])

    respond_to do|format|
      format.js { render :js=>"$('.selected_item_area').html('<img src=#{ @image.image_url(:thumb)}><br/><input type=hidden id=disc_img value=#{@image.id} name=image_id >')"}
    end

  end

end
