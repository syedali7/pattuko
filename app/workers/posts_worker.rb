class PostsWorker
	include Sidekiq::Worker

	def related(post_id)
		post = Post.where(:id => post_id).first
	    if post.posting_type == 'Movie'
	    	movie = Movie.find(post.posting_id)
	    	related_posts = Post.where(:posting_type => 'Movie', :posting_id => post.posting_id)
	    	events = Event.where(:eventable_type => 'Movie', :eventable_id => post.posting_id)
	    	event_post_ids = []
	    	events.each do |e|
	    		event_post_ids << e.id	
	    	end
	    	event_post_ids.each do |ep|
	    		related_posts << Post.where(:posting_type => 'Event', :posting_id => ep)
	    	end
	    	#related_posts = related_posts + Event.where(:eventable_type => 'Movie', :eventable_id => post.posting_id)
	      	related_movie_posts(related_posts,post,movie)
	    elsif post.posting_type == 'Artist'
	    	posts = Post.where(:posting_type => 'Artist', :posting_id => post.posting_id)
	        self.related_artist_posts(post, posts)
	    elsif post.posting_type == 'Event'
	    	related_posts = Post.where(:posting_type => 'Event', :posting_id => post.posting_id)
	    	self.related_event_posts(post,related_posts)
			event = Event.find(post.posting_id)
			unless event.eventable_type.nil?
		    	if event.eventable_type == 'Movie'
		    		movie = Movie.where(:id => event.eventable_id).first
		    		related_posts = Post.where(:posting_type => 'Movie', :posting_id => event.eventable_id)
		    		self.related_movie_posts(related_posts,post,movie)
		    	elsif event.eventable_type == 'Artist'
		    		posts = Post.where(:posting_type => 'Artist', :posting_id => event.eventable_id)
		    		self.related_artist_posts(post,posts)
		    	end
		    end
	    end 
	end


	def related_movie_posts(related_posts,post,movie)
      if related_posts.empty?
        if movie.hero?
          posts = Post.where(:posting_type => 'Artist', :posting_id => movie.hero.id)
          unless posts.empty?
            posts.each do |p|
              if p.id != post.id
                rp = RelatedPost.where(:post_id => post.id, :related_post_id => p.id).first
                if rp.nil?
                  	RelatedPost.create(:post_id => post.id, :related_post_id => p.id)
                  	pr = RelatedPost.where(:post_id => p.id, :related_post_id => post.id).first
					if pr.nil?
						RelatedPost.create(:post_id => p.id, :related_post_id => post.id)
					end
                  puts 'post for hero'
                end
              end
            end
          end
        elsif movie.heroine?
          posts = Post.where(:posting_type => 'Artist', :posting_id => movie.heroine.id)
          unless posts.empty?
            posts.each do |p|
              if p.id != post.id
                rp = RelatedPost.where(:post_id => post.id, :related_post_id => p.id).first
                if rp.nil?
                  	RelatedPost.create(:post_id => post.id, :related_post_id => p.id)
                  	pr = RelatedPost.where(:post_id => p.id, :related_post_id => post.id).first
					if pr.nil?
						RelatedPost.create(:post_id => p.id, :related_post_id => post.id)
					end
                  puts 'post for heroine'
                end
              end
            end
          end
        elsif movie.director?
          posts = Post.where(:posting_type => 'Artist', :posting_id => movie.director.id)
          unless posts.empty?
            posts.each do |p|
              if p.id != post.id
                rp = RelatedPost.where(:post_id => post.id, :related_post_id => p.id).first
                if rp.nil?
                  	RelatedPost.create(:post_id => post.id, :related_post_id => p.id)
                  	pr = RelatedPost.where(:post_id => p.id, :related_post_id => post.id).first
					if pr.nil?
						RelatedPost.create(:post_id => p.id, :related_post_id => post.id)
					end
                  puts 'post for director'
                end
              end
            end
          end
        elsif movie.music_director?
          posts = Post.where(:posting_type => 'Artist', :posting_id => movie.music_director.id)
          unless posts.empty?
            posts.each do |p|
              if p.id != post.id
                rp = RelatedPost.where(:post_id => post.id, :related_post_id => p.id).first
                if rp.nil?
                 	RelatedPost.create(:post_id => post.id, :related_post_id => p.id)
                  	pr = RelatedPost.where(:post_id => p.id, :related_post_id => post.id).first
					if pr.nil?
						RelatedPost.create(:post_id => p.id, :related_post_id => post.id)
					end
                  puts 'post for mus_director'
                end
              end
            end
          end
        elsif movie.producer?
          posts = Post.where(:posting_type => 'Artist', :posting_id => movie.producer.id)
          unless posts.empty?
            posts.each do |p|
              if p.id != post.id
                rp = RelatedPost.where(:post_id => post.id, :related_post_id => p.id).first
                if rp.nil?
                  	RelatedPost.create(:post_id => post.id, :related_post_id => p.id)
                  	pr = RelatedPost.where(:post_id => p.id, :related_post_id => post.id).first
					if pr.nil?
						RelatedPost.create(:post_id => p.id, :related_post_id => post.id)
					end
                  puts 'post for producer'
                end
              end
            end
          end
        end
      else 
      	logger.debug(related_posts) 
      	logger.debug(post)
        related_posts.each do |p|
          unless p.attributes == post.attributes
            rp = RelatedPost.where(:post_id => post.id, :related_post_id => p.id).first
            if rp.nil?
              	RelatedPost.create(:post_id => post.id, :related_post_id => p.id)
              	pr = RelatedPost.where(:post_id => p.id, :related_post_id => post.id).first
				if pr.nil?
					RelatedPost.create(:post_id => p.id, :related_post_id => post.id)
				end
              puts 'post for movie'
            end
          end
        end
      end
	end

	def related_artist_posts(post,posts)
	    unless posts.empty?
	      posts.each do |p|
	        if p.id != post.id
	          rp = RelatedPost.where(:post_id => post.id, :related_post_id => p.id).first
	          if rp.nil?
	          	RelatedPost.create(:post_id => post.id, :related_post_id => p.id)
	           	pr = RelatedPost.where(:post_id => p.id, :related_post_id => post.id).first
				if pr.nil?
					RelatedPost.create(:post_id => p.id, :related_post_id => post.id)
					end
	            puts 'post for artist'
	            end
	          end
	        end
	    end
	end

	def related_event_posts(post,related_posts)
	    unless related_posts.empty?
	      related_posts.each do |p|
	        if p.id != post.id
	          rp = RelatedPost.where(:post_id => post.id, :related_post_id => p.id).first
	          if rp.nil?
	          	RelatedPost.create(:post_id => post.id, :related_post_id => p.id)
	           	pr = RelatedPost.where(:post_id => p.id, :related_post_id => post.id).first
				if pr.nil?
					RelatedPost.create(:post_id => p.id, :related_post_id => post.id)
					end
	            puts 'post for event'
	            end
	          end
	        end
	    end
	end

	def testing(post_id)
		puts "testing method"
	end

	def feed(post_id)
	    user_ids = []
	    post = Post.find(post_id)
	    if (post.posting_type == "Movie")
	      	movie_id = Movie.find(post.posting_id).id
	      	user_ids = Fan.where(:fan_id => movie_id).map(&:user_id)
	      	artist_ids = []
	      	ma = Movie.find(movie_id).artists
	      	ma.each do |a|
	        	artist_ids << a.id
	      	end
	      	artist_ids = artist_ids.uniq
	      	artist_ids.each do |a|
	        	artist_type_id = MovieArtist.where(:artist_id => a).map(&:artist_type_id).first
	        	hero = ArtistType.find_by_name("Hero")
	        	director = ArtistType.find_by_name("Directed by")
	        	if (artist_type_id == hero.id || artist_type_id == director.id)
	        		user_ids = user_ids + Fan.where(:fan_id => a).map(&:user_id)
	        	end
	      	end
	    elsif (post.posting_type == "Artist")
	      	artist_id = Artist.find(post.posting_id).id
	      	user_ids = Fan.where(:fan_id => artist_id).map(&:user_id)
	    end
	    user_ids = user_ids.uniq
	    user_ids.each do |user_id|
	    	feed = Feed.where(:user_id => user_id , :post_id => post.id).first
	      	if feed.nil?
	        	feed = Feed.create(:user_id => user_id , :post_id => post.id, :post_created_on => post.created_at )
	      	end
	    end
	end

	def fan_follow_feed(posts,user_id)
	    posts.each do |p|
	    	post_feed = Feed.where(:post_id => p.id, :user_id => user_id).first
	      	if post_feed.nil?
	        	feed = Feed.create(:user_id => user_id , :post_id => p.id, :post_created_on => p.created_at )
	      	end
	    end
	end

	def album_scrap(scrap_hash)

		begin
			require 'rubygems'
		    require 'nokogiri'
		    require 'open-uri'

		    posting_type = scrap_hash["posting_type"]
		    user_id = scrap_hash["user_id"]
		    home_url = scrap_hash["scrap_url"]
		    domain = home_url.split('/')[2]

			if domain == "timesofcity.com"

			    d =  Nokogiri::HTML(open(home_url))
			    title = d.css('h2').text
			    count = d.css('.counter').text.split("of ").last.to_i
			    val_id = d.css('.ngg-browser-next').first.attributes['href'].value.split('=').last.to_i
			    album = Album.create(:album_name => title)
			    (0...count).each do |page|
			      domain_url  = d.css('.ngg-browser-next').first.attributes['href'].value.split('=').first
			      next_url = "http://timesofcity.com" + domain_url.to_s + "=" + val_id.to_s
			      open_url = Nokogiri::HTML(open(next_url))
			      image_url =  open_url.css('.pic').css('a').first.attributes['href'].value
			      val_id = val_id + 1

			      self.image_creation(image_url,album)
			    end
			    self.post_creation(album,posting_type,title,user_id,scrap_hash)

			elsif domain == "tollywood.net"

				d =  Nokogiri::HTML(open(home_url))
			    title = d.css('.header_rgt')[1].text
			    puts title
				image_count = d.css('.tollywood_lightbox').count
				first_str = home_url.split('Album')[0]
				second_str = home_url.split('Album')[1]
				page_count = 0
				album = Album.create(:album_name => title)
				(0...image_count).each do |page|
					sub_url = first_str + "Photos" + second_str + "/images" + page_count.to_s + ".htm"
					d1 = Nokogiri::HTML(open(sub_url))
					encode_image_url = d1.css('.big_img').css('img').first.attributes['src'].value
					image_url = URI::encode(encode_image_url)
					puts image_url
					page_count = page_count + 1
					self.image_creation(image_url,album)
				end
				self.post_creation(album,posting_type,title,user_id,scrap_hash)

			elsif domain == "www.supergoodmovies.com"

			    d =  Nokogiri::HTML(open(home_url))
			    title = d.css('h1').text.strip.split('(')[0].strip
			    puts title
			    image_count = d.css('.singlemoviegallery_div').css('.gallery_img')
			    album = Album.create(:album_name => title)
			    image_count.each do |page|
			    	sub_url = page.css('a').first.attributes['href'].value
			    	d1 =  Nokogiri::HTML(open(sub_url))
			    	image_url = d1.css('.galleryimage_div').css('img').first.first[1]
			    	puts image_url
			    	self.image_creation(image_url,album)
			    end
			    self.post_creation(album,posting_type,title,user_id,scrap_hash)

			elsif domain == "www.tollytrendz.com"

			    d =  Nokogiri::HTML(open(home_url))
			    title = d.css('h1').text
			    puts title
			    album = Album.create(:album_name => title)
			    unless d.css('.pageiing').empty?
			    	paging = d.css('.pageiing').text.strip.split(" of ")[1].to_i
			    	n_url = d.css('.next_bz').first.parent.first[1]
			    	num = n_url.split('pid=')[1].to_i
			    	(0...paging).each do |page|
				    	gal_name = n_url.split('pid=')[0]
				    	next_url = "http://www.tollytrendz.com" + gal_name + "pid=" + num.to_s
				    	puts next_url
				    	d1 =  Nokogiri::HTML(open(next_url))
				    	image_url = d1.css('.gdiv').css('a').first.attributes['href'].value
				    	puts image_url
				    	num = num + 1
				    	self.image_creation(image_url,album)
				    end
			    else
			    	home_url = "http://www.tollytrendz.com" + d.css('.gallery').css('li').first.css('a').first.attributes['href'].value
			    	d =  Nokogiri::HTML(open(home_url))
			    	paging = d.css('.pageiing').text.strip.split(" of ")[1].to_i
			    	n_url = d.css('.next_bz').first.parent.first[1]
			    	num = n_url.split('pid=')[1].to_i
			    	(0...paging).each do |page|
				    	gal_name = n_url.split('pid=')[0]
				    	next_url = "http://www.tollytrendz.com" + gal_name + "pid=" + num.to_s
				    	puts next_url
				    	d1 =  Nokogiri::HTML(open(next_url))
				    	image_url = d1.css('.gdiv').css('a').first.attributes['href'].value
				    	puts image_url
				    	num = num + 1
				    	self.image_creation(image_url,album)
				    end
			    end
			    self.post_creation(album,posting_type,title,user_id,scrap_hash)
			    
			end
		rescue
			home_url = scrap_hash["scrap_url"]
			user_id = scrap_hash["user_id"]
			username = User.find(user_id).username
			#Sample.album_scrap_failure(username,home_url).deliver!			
		end
	end

	def image_creation(image_url,album)
		`wget -P public/tmp/album_post_images "#{image_url}"`
     	file_name = image_url.split('/').last
     	image = File.open(Rails.public_path.to_s + '/tmp/album_post_images'+ '/' + file_name)
    	post_image = Image.create(:image => image)
    	AlbumImage.create(:album_id => album.id , :image_id => post_image.id)
	end

	def post_creation(album,posting_type,title,user_id,scrap_hash)

		mention_movie_id = scrap_hash["mention_movie_id"]
		mention_artist_id = scrap_hash["mention_artist_id"]
		album.cover_image_id = album.images.first.id
	    album.save!

	    type = posting_type
	    tmp = type.split('-')[1]
	    type_string = tmp.split('_')[0]
	    type_id = tmp.split('_')[1]
	    
	    posting_type = ''
	    if type_string == "movie"
	      posting_type = 'Movie'
	    elsif type_string == "artist"
	      posting_type = 'Artist'
	    elsif type_string == "event"
	      posting_type = 'Event'
	    end

	    begin
	    	date = Date.parse(scrap_hash["date"])
	    rescue
	    	date = Time.now
	    end

	    post = Post.create!( :title => title , :posting_id => type_id,
	         :posting_type => posting_type, :postable_type => 'Album', :postable_id => album.id , 
	          :user_id => user_id, :post_to_facebook => 0, :created_at => date )

	    album.post_id = post.id
	    album.save

	    username = User.find(user_id).username
	    post_id = post.id

	    Sample.album_scrap_success(post,username).deliver!

	    self.related(post_id)
	    self.feed(post_id)
	    Post.mention(post,mention_artist_id,mention_movie_id)
	    feed = Feed.create(:user_id => user_id ,:post_id => post.id, :post_created_on => post.created_at )
	end

	def perform(post_id, type, scrap_hash)
		if type == 1
			self.related(post_id)
		elsif type == 2
			self.feed(post_id)
		elsif type == 3
			self.album_scrap(scrap_hash)
		end
  	end

  	#Sidekiq::Queue['inline'].limit = 1
end
