#class PostSweeper < ActionController::Caching::PostSweeper
	#observe Post 

	#def sweep(post)
	#	expire_page posts_path
	#end

	#def sweep(post)
	 #   expire_cache_for(post)
	#end

	#alias_method :after_create, :sweep
#end