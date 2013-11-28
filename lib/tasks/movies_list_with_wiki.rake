task :wiki_urls => :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

	Movie.where('year >? and id >= ?', '2008', 1).each do |movie|
		if movie.wiki_url.nil?
			movie_url = "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{movie.name.gsub(' ', '+').gsub('"','')}"
			url = URI::encode(movie_url)
	    	test = Nokogiri::HTML(open(url))
	    	parsed_json = JSON.parse(test)
		    wiki_url = ''
		    unless parsed_json["responseData"].nil?
			    json_results = parsed_json["responseData"]["results"]
			    json_results.each do |obj|
			    	unless obj['url'].index('wiki').nil? 
			    		wiki_url = obj['url']
			    		movie.wiki_url = wiki_url
			    		puts wiki_url
			    		movie.save
			    		break
			    	end
			    end
		    end
		end
		puts movie.id.to_s
	end
end