task :related_movies => :environment do
	Movie.where('year >= ?', '2005').each do |movie|
		hero = movie.hero
		heroine = movie.heroine 
		director = movie.director
		music_director = movie.music_director
		producer = movie.producer
		if hero != nil && heroine != nil && director != nil && music_director != nil && producer != nil 
			movie_artist = MovieArtist.where(:artist_id => [hero.id, heroine.id, director.id, music_director.id, producer.id])
			unless movie_artist.empty?
				group = movie_artist.group_by(&:movie)
				group.each do |key,value|
					unless key.nil?
						movie_weight = 0
						unless key.hero.nil?
							fans = key.hero.fans.count == 0 ? 1 : key.hero.fans.count
							movie_weight += fans * 30
						end
						unless key.heroine.nil?
							fans = key.heroine.fans.count == 0 ? 1 : key.heroine.fans.count
							movie_weight += fans * 25
						end
						unless key.director.nil?
							fans = key.director.fans.count == 0 ? 1 : key.director.fans.count
							movie_weight += fans * 20
						end
						unless key.music_director.nil?
							fans = key.music_director.fans.count == 0 ? 1 : key.music_director.fans.count
							movie_weight += fans * 15
						end
						unless key.producer.nil?
							fans = key.producer.fans.count == 0 ? 1 : key.producer.fans.count
							movie_weight += fans * 10
						end
						month_before = (Time.now - 1.month).strftime('%Y-%m-%d') 
						month_after = (Time.now + 1.month).strftime('%Y-%m-%d')
						unless key.release_date.nil?
							if key.release_date >= month_before && key.release_date <= month_after
								movie_weight += 100
							end
						end
						if movie.id != key.id
							reason = movie.name + 'matches with' + key.name 
							rm = RelatedMovie.where(:movie_id => movie.id, :related_movie_id => key.id).first
							if rm.nil?
								RelatedMovie.create(:movie_id => movie.id, :related_movie_id => key.id, :weight => movie_weight, :reason => reason)
							end
						end
						puts movie.name + ' related_movie ' + key.name + ' has weightage ' + movie_weight.to_s
					end
				end
			end
		end
	end
end


task :related_posts => :environment do 
	Post.all.each do |post|
		if post.posting_type == 'Movie'
			related_posts = Post.where(:posting_type => 'Movie', :posting_id => post.posting_id)
			if related_posts.empty?
				movie = Movie.find(post.posting_id)
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
				related_posts.each do |p|
					if p.id != post.id
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
		elsif post.posting_type == 'Artist'
			posts = Post.where(:posting_type => 'Artist', :posting_id => post.posting_id)
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
	end
end

task :trending_artists => :environment do
	MovieArtist.all.group_by(&:artist).each do |artist, value|
		unless artist.nil?
			count_arr = []
			arr = value.group_by(&:artist_type)
			unless arr.empty?
				arr.each do |at, ma|
					unless at.nil?
						count_arr << { :count => ma.count , :artist_type_id => at.id, :name => at.name, :artist_name => artist.name}
					end
				end
				types = ''
				count_arr.sort_by { |val| val[:count]*-1 }[0..2].each do |item|
					unless item.nil?
						tmp = item[:name]
						types += tmp + '/'
					end
				end
				artist.profession = types
				artist.save
				puts types

=begin
			value.group_by(&:artist_type).each do |at,ma|
				unless at.nil?
					ArtistProfession.create(:artist_id => artist.id, :artist_type_id => at.id, :weight => ma.count)
					puts artist.name + ' as ' + at.name
				end
			end
=end
			end
		end
	end 
end	

task :shorten_related_movies => :environment do 
	Movie.where('year >= ?', '2005').each do |movie|
		rms = movie.related_movies.order('weight DESC').limit(5)
		rms.each do |rm|
			sql = "INSERT INTO dummy (`id`,`movie_id`, `related_movie_id`, `weight`,`created_at`,`updated_at`, `reason`) 
			values (#{rm.id},#{rm.movie_id}, #{rm.related_movie_id}, #{rm.weight},now(), 
				now(), '#{rm.reason}')"
			ActiveRecord::Base.connection.execute(sql)
		end
		
	end
end


