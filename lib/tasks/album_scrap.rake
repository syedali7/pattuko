task :times_of_city_album_scrap => :environment do
	require 'rubygems'
  	require 'nokogiri'
  	require 'open-uri'
  	home_url = "http://timesofcity.com/gallery/asha-saini-latest-photo-gallery"
    d =  Nokogiri::HTML(open(home_url))
    title = d.css('h1').text
	count = d.css('.counter').text.split("of ").last.to_i
	val_id = d.css('.ngg-browser-next').first.attributes['href'].value.split('=').last.to_i

	(0...count).each do |page|
		domain_url  = d.css('.ngg-browser-next').first.attributes['href'].value.split('=').first
		next_url = "http://timesofcity.com" + domain_url.to_s + "=" + val_id.to_s
		open_url = Nokogiri::HTML(open(next_url))
		puts open_url.css('.pic').css('a').first.attributes['href'].value
		val_id = val_id + 1
		puts val_id
	end
end

task :tollywood_dot_net_album_scrap => :environment do
	require 'rubygems'
  	require 'nokogiri'
  	require 'open-uri'
  	home_url = "http://tollywood.net/Gallery/Album/2791/ACTOR/ANR+press+meet"
    d =  Nokogiri::HTML(open(home_url))
    scrap_title = d.css('.header_rgt')[1].text
    puts scrap_title
	image_count = d.css('.tollywood_lightbox').count
	first_str = home_url.split('Album')[0]
	second_str = home_url.split('Album')[1]
	page_count = 0
	(0...image_count).each do |page|
		sub_url = first_str + "Photos" + second_str + "/images" + page_count.to_s + ".htm"
		d1 = Nokogiri::HTML(open(sub_url))
		encode_image_url = d1.css('.big_img').css('img').first.attributes['src'].value
		puts encode_image_url
		image_url = URI::encode(encode_image_url)
		puts image_url
		`wget -P public/tmp/album_post_images "#{image_url}"`
		page_count = page_count + 1
	end
end

task :super_good_movies_album_scrap => :environment do
	require 'rubygems'
  	require 'nokogiri'
  	require 'open-uri'
  	home_url = "http://www.supergoodmovies.com/58310/tollywood/doosukeltha-movie-gallery"
    d =  Nokogiri::HTML(open(home_url))
    title = d.css('h1').text.strip.split('(')[0].strip
    puts title
    image_count = d.css('.singlemoviegallery_div').css('.gallery_img')
    image_count.each do |page|
    	sub_url = page.css('a').first.attributes['href'].value
    	d1 =  Nokogiri::HTML(open(sub_url))
    	image_url = d1.css('.galleryimage_div').css('img').first.first[1]
    	puts image_url
    end
end

task :tollytrendz_album_scrap => :environment do
	require 'rubygems'
  	require 'nokogiri'
  	require 'open-uri'
  	home_url = "http://www.tollytrendz.com/isha-chawla-hot-pics/"
    d =  Nokogiri::HTML(open(home_url))
    title = d.css('h1').text
    puts title
    unless d.css('.pageiing').empty?
    	paging = d.css('.pageiing').text.strip.split(" of ")[1].to_i
    	n_url = d.css('.next_bz').first.parent.first[1]
    	num = n_url.split('pid=')[1].to_i
    	(0...paging).each do |page|
	    	gal_name = n_url.split('pid=')[0]
	    	next_url = "http://www.tollytrendz.com" + gal_name + "pid=" + num.to_s
	    	puts next_url
	    	d1 =  Nokogiri::HTML(open(next_url))
	    	image_url = d1.css('.gdiv').css('a').first.attributes['href'].value
	    	puts image_url
	    	num = num + 1
	    end
    else
    	home_url = "http://www.tollytrendz.com" + d.css('.gallery').css('li').first.css('a').first.attributes['href'].value
    	d =  Nokogiri::HTML(open(home_url))
    	paging = d.css('.pageiing').text.strip.split(" of ")[1].to_i
    	n_url = d.css('.next_bz').first.parent.first[1]
    	num = n_url.split('pid=')[1].to_i
    	(0...paging).each do |page|
	    	gal_name = n_url.split('pid=')[0]
	    	next_url = "http://www.tollytrendz.com" + gal_name + "pid=" + num.to_s
	    	puts next_url
	    	d1 =  Nokogiri::HTML(open(next_url))
	    	image_url = d1.css('.gdiv').css('a').first.attributes['href'].value
	    	puts image_url
	    	num = num + 1
	    end
    end
end