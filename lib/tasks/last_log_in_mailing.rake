task :last_log_in_mailing => :environment do
	User.all.each do |u|
  		if u.last_log_in_at == Time.now - 3.day
  			unless u.email.nil?
  				Sample.last_log_in_mailing(u.username, u.email).deliver!
  			end
  		end
  	end
end


task :album_cover_image => :environment do
	Album.all.each do |a|
  		a.cover_image_id = a.images.first.id
  		a.save
  	end
end
