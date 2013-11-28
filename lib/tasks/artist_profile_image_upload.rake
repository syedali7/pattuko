task :artist_profile_image_upload => :environment do
	Artist.all.each do |artist|
		unless artist.nil?
			id = artist.id.to_s
			puts id
			begin	
				file_name = id + '.jpg'
				artist_name = artist.name.gsub!(/\s/,'-')
				if artist_name.nil?
					artist_name = artist.name
				end
				new_file_name = id + '-' + artist_name + '-profile_pic.jpg'
				puts artist_name
				
				File.rename(Rails.public_path.to_s + '/tmp/artist_profile_images'+ '/' + file_name,
					Rails.public_path.to_s + '/tmp/artist_profile_images'+ '/' + new_file_name)
				
				puts file_name
				puts new_file_name
				if artist.artist_profile_image.blank?
					artist.artist_profile_image = File.open(Rails.public_path.to_s + '/tmp/artist_profile_images'+ '/' + new_file_name)
					artist.save
					puts 'saved'
				end

			rescue
				next
			end
		end
	end

end