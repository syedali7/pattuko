desc "movies with no movie images"
task :no_movie_image=>:environment do
   @movies=Movie.select('id,name').find(:all,:conditions=>['movie_image is ?',nil])
   Sample.no_image(@movies).deliver
end
