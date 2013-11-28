task :list_of_theatres => :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

	(0...14).each do |page|
		home_url = "http://www.qcn.in/theatres/Andhra-Pradesh?page=" + (page).to_s
		puts home_url
		d =  Nokogiri::HTML(open(home_url))
    	d.css('.view').children.css('tbody').children.css('tr').each do |tr|
    		th = tr.css('td')[0].text
    		theatre = th.strip
    		puts theatre

    		c = tr.css('td')[1].text
    		city = c.strip
    		puts city

    		d =  tr.css('td')[2].text
    		district = d.strip
    		puts district

    		l =  tr.css('td')[3].text
    		location = l.strip
    		puts location

    		s =  tr.css('td')[4].text
    		seat = s.strip
    		seats = seat.to_i
    		puts seats

    		r = tr.css('td')[5].text
    		rating = r.strip
    		puts rating

    		Theatre.create(:theatre => theatre ,:city => city, :district => district,
    			:location => location, :seats => seats, :rating => rating)
    	end
  	end

end
