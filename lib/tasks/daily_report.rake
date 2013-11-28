task :daily_report => :environment do
	posts = Post.where("created_at >= ?",1.day.ago)
	movies = Movie.where("created_at >= ?",1.day.ago)
	artists = Artist.where("created_at >= ?",1.day.ago)
	post_title = Array.new
	movie_name = Array.new
	artist_name = Array.new
	posts.each do |p|
		post_title << p.title
	end
	movies.each do |m|
		movie_name << m.name
	end
	artists.each do |a|
		artist_name << artist.name
	end
	Sample.daily_report(movie_name,artist_name, post_title).deliver!
end