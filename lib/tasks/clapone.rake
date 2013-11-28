task :clapone_styles => :environment do 
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	url = 'http://clapone.com/'
	doc = Nokogiri::HTML(open(url))
	doc.css('.box').each do |artist|
		link = artist.css('a').first.attributes['href'].value
		page_doc = Nokogiri::HTML(open(link))
		page_doc.css('.browse-view').css('.division').each do |sty|
			style_image_url = sty.css('.col4').css('img').first.attributes['src'].value()
			puts style_image_url
			`wget -P public/tmp/styles/ #{style_image_url}`
			file_path = style_image_url.split('/').last
			s = Style.create(:image => File.open(Rails.public_path.to_s + '/tmp/styles/' + file_path))
			sty.css('.col3').each do |store|
				store_url = store.css('a').first.attributes['onclick'].value.split(',').first.gsub("hitsfunc('", "").gsub("'", '')
				Product.create(:style_id => s.id, :product_url => store_url)
				puts style_image_url
				puts store_url
			end
		end
	end
end
