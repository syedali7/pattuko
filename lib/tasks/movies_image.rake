task :movie_image => :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

  Movie.where('year >?', '2008').each do |movie|
  	unless movie.wiki_url.nil?
  		wiki_url = movie.wiki_url 
			page = Nokogiri::HTML(open(wiki_url))
  		box_image = page.css('#mw-content-text').children.css('table')[0].css('tr')[1]
  		url = box_image.css('a').children.css('img').first.attributes['src'].value
  		puts url
  		image_url = "http:" + url
  		puts image_url
      `wget -P public/tmp/movie_images/#{movie.id} #{image_url}`
      file_name = image_url.split('/').last
      movie.movie_image = File.open(Rails.public_path + '/tmp/movie_images'+ '/' + movie.id.to_s + '/' + file_name)
      movie.thumb_height = Magick::Image::read(Rails.public_path + URI.parse(movie.movie_image.url(:medium)).path).first.rows
      movie.save!
  	end
  end
end