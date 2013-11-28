task :reindex => :environment do 
	
require 'tire'
require 'yajl/json_gem'

Tire.index 'movies' do
  delete
  create

ms = Array.new
Movie.all.each do |movie| ms << movie.attributes end
  Tire.index 'movies' do
    import ms
  end
end

s = Movie.search 'movies' do
    query do
      string 'name:T*'
    end
end

  s.results.each do |document|
    puts "* #{ document.name } "
  end

end
