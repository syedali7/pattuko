namespace :no_artists do
    desc "movies_with_no_artists" 
    task :movie=>:environment do
      @movies=Array.new
      Movie.all.each do |m|
       if m.artists.count==0
	@movies << m
       end
      end
      Sample.movies_with_no_art(@movies).deliver
    end
end
