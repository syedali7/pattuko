task :movie_image_upload => :environment do
	Movie.where('year >?', '2008').each do |movie|
		unless movie.nil?
			id = movie.id.to_s
			puts id
			begin	
				file_name = id + '.jpg'
				movie_name = movie.name.gsub!(/\s/,'-')
				if movie_name.nil?
					movie_name = movie.name
				end
				new_file_name = id + '-' + movie_name +  '.jpg'
				puts movie_name
				unless movie.hero.nil?
					h = movie.hero.name
					hero = h.gsub!(/\s/,'-')
					if hero.nil?
						hero = movie.hero.name
					end
					new_file_name = id + '-' + movie_name + '-' + hero + '.jpg'
					puts hero
					unless movie.heroine.nil?
						hr = movie.heroine.name
						heroine = hr.gsub!(/\s/,'-')
						if heroine.nil?
							heroine = movie.heroine.name
						end
						new_file_name = id + '-' + movie_name + '-' + hero + '-' + heroine + '.jpg'
						puts heroine
					end
				end
				
				File.rename(Rails.public_path.to_s + '/tmp/movie_images'+ '/' + file_name,
					Rails.public_path.to_s + '/tmp/movie_images'+ '/' + new_file_name)
				
				puts file_name
				puts new_file_name
				if movie.movie_image.blank?
					movie.movie_image = File.open(Rails.public_path.to_s + '/tmp/movie_images'+ '/' + new_file_name)
					movie.save
					puts 'saved'
				end

			rescue
				next
			end
		end
	end

end

task :to_edit_movies => :environment do 
	Movie.where('year >= ?', 2005).each do |m|
      if m.hero.nil? || m.heroine.nil? || m.director.nil? || m.music_director.nil?
        m.edited = 1
        m.save
      end
    end

end
