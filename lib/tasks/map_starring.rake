task :map_maincast => :environment do
	Movie.all.each do |m|
		ma = MovieArtist.where(:movie_id => m.id, :artist_type_id => 3).first
		unless ma.nil?
			ma.artist_type_id = 29 
			ma.save
		end
	end
end