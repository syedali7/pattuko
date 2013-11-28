require 'sidekiq/web'

Movies::Application.routes.draw do

  root :to => 'posts#index'

  mount Sidekiq::Web, at: '/sidekiq'
    
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get '/related_posts' => 'posts#related_posts'


  get '/user_posts' => 'users#user_posts'

  resources :activities do
  end

  resources :admin do
   
  end
  resources :favourites

  resources :feeds do
  end

  resources :discussions do
    member do
      get 'create_message'
      get 'message'
      get '/:tagable_type/:tagable_id',to: 'discussions#movie_artist'
      post 'message_create'
      get 'discussion_messages'
    end
    collection do
      get "select"
    end
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
    # match '/:id' => 'high_voltage/pages#show', :as => :page, :via => :get
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products


  resources :artists do
      collection do
        post 'preferences_of_artists'
        post 'movie_artists_quick_edit'
        post 'user_artist_create'
        post 'artist_fan'
        get 'birthday'
        get 'artist_posts'
        get 'artist_movies'
      end

      member do
        get 'involved_movies'
        get 'query'
        get 'get_artist_name'
        post 'upload' 
        post 'bday_greeting'
        get 'posts'
        get 'videos'
        get 'photos'
        get 'movies'
      end
  end

  resources :movies, :expect => :show do
      resources :posts
      collection do
        post 'preferences_of_movies'
        post 'preferences_of_languages'
        post 'user_movie_create'
        post 'movie_fan'
        post 'cast_crew'
        post 'fans'
        post 'photos'
        post 'related_posts'
        post 'movie_ratings'
        post 'artist_fan'
        post 'movie_reviews'
        post 'reviews_like'
        post 'load_reviews'
        post 'load_movie_rating'
        post 'load_moviefans_count'
        post 'load_review_likes'
        post 'load_artistfans_count'
        post 'autocompleat_movie'
        
      end

      member do
        get 'activities'
        get 'reviews'
        get 'relatedmovies'
        get 'get_movie_name'
        get 'navigation'           
        get 'query'
        post 'upload'
        get 'reviews'
      end
  end
  
  resources :comments do
    collection do
      post 'comment_like'
      post 'comment_delete'
    end
  end

  resources :posts do
    resources :comments 
    get 'load_comments'
    get 'load_show_page_comments'
    get 'load_home_page_comments'
    get 'comment_load_homepage'
    get 'load_fans_count'
    get 'more_people_involved'
    get 'hover_content'
    get 'post_content_edit'
    get 'block',:on=>:member
    get 'trending',:on=>:member
    collection do
        post 'news_create'
        post 'video_create'
        post 'image_create'
        post 'review_create'
        get 'album_create'
        get 'load_news'
        get 'news'
        get 'movies'
        get 'artists'
        get 'albums'
        get 'load_movies'
        get 'load_artists'
        get 'load_albums'
        get 'follow_movies'
        get 'follow_artists'
        get 'wood_selection'
        post 'fan_follow'
        post 'favourite'
        post 'clap'
        post 'show_page_comment'
        post 'home_page_comment'
        post 'user_event_create'
        get 'related_posts'
        post 'trusted'
        post 'polling'
        get 'recently_viewed_news'
        get 'recently_viewed_posts'
        get 'facet_search'
        post 'top_search'
        get 'news_scrapping'
        get 'album_scrapping'
        post 'album_cover_image_change'
        post 'post_edit'
        post 'delete_album_photo'
        get 'create_popup_code'
        post 'index_newsurls'
    end
    member do
      get 'event_query'
    end
  end

  resources :shop do
    member do
      get 'style_update_render'
    end
    collection do
      post 'style_clap'
      post 'style_update'
    end
  end

  resource :pages do
    collection do 
      get 'about'
    end
  end

  resources :outlinks do
    collection do
      post 'shop_outlink'
    end
  end

  resources :images do
    collection do 
      get 'images_select_album_create_render'
      post 'images_select_album_create'
      post 'discussions'
    end
    resources :comments do
      collection do
        post 'image_comment_create'
      end
    end
    get 'load_image_comments'
  end

  resources :users do
    get 'notifications',on: :collection
    collection do
      get 'show'
      get 'user_posts'
    end
  end
  resources :newsurls do
    collection do
      post 'newsurl_delete'

    end  
    root :to => 'newsurls#index'
  end  

  resources :activities do
    collection do
      post 'feedback'
      
    end
  end

  resources :photos do
    member do
      get 'artists'
      get 'movies'
    end
  end

  resources :videos do
    collection do
      get 'artists'
      get 'movies'
    end
  end

  post 'album' => 'newsurls#album_urls'
  get 'albums' => 'posts#albums'

  get 'news' => 'posts#news'

  get 'feedback' => 'activities#show'

  get 'about' => 'pages#about'


  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  #match ':permalink', :controller => 'pages', :action => 'show'
   

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  get '/movies/*name/:id' => 'posts#show'
  get '/artists/*name/:id' => 'posts#show'
  get '/events/*name/:id' => 'posts#show'
  get '/movie/:movie' => 'posts#index'
  get '/artist/:artist' => 'posts#index'
end
