task :movie_hero_check => :environment do
#this is for checking the wikipedia starring with hero and imdb starring hero.. code pending
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

	Movie.where('year >?', '2008').each do |movie|
	  	unless movie.wiki_url.nil?
	  		wiki_url = movie.wiki_url 
	  		begin
	  			page = Nokogiri::HTML(open(wiki_url))
				box = page.css('#mw-content-text').children.css('table')[0].css('tr')[6]
				title = box.children.css('li')[0].css('a').text
				title = box.css('a')[0].text
				puts title
			rescue
				next
			end
		end
	end
end