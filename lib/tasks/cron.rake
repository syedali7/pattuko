task :mysql_backup => :environment do 

	require 'fog'

	file_name = Time.now.strftime('%Y_%m_%d').to_s
	`mysqldump --quick --single-transaction --create-options -uroot -ptechbots@16 pattuko_production | gzip > public/#{file_name}.gz`
	con = Fog::Storage.new({
	     :provider                 => 'AWS',
	     :aws_secret_access_key    => 'DFpTn15jvRdi4Gus3D22tDXl1ixfOZIikEyxoeqi',
	     :aws_access_key_id        => 'AKIAJUJWBWRZ7T4NY4IA'
	  })
	bucket = con.directories.get('famru_prod')

	bucket.files.create(:key => "db_backup/#{file_name}.gz", 
  		:body => File.open(Rails.public_path.to_s + "/#{file_name}.gz"),
      :public => true)
	
end

task :album_cron => :environment do
	AlbumTemp.all.each do |at|
		if at.done == false
			begin
				require 'rubygems'
			    require 'nokogiri'
			    require 'open-uri'

			    posting_type = at.posting_type
			    user_id = at.user_id
			    home_url = at.url.strip
			    men_mov_id = at.mention_movie_id
			    men_art_id = at.mention_artist_id
			    c_date = at.date
			    domain = home_url.split('/')[2]

				if domain == "timesofcity.com"

				    d =  Nokogiri::HTML(open(home_url))
				    title = d.css('h2').text
				    count = d.css('.counter').text.split("of ").last.to_i
				    val_id = d.css('.ngg-browser-next').first.attributes['href'].value.split('=').last.to_i
				    album = Album.create(:album_name => title)
				    (0...count).each do |page|
				      domain_url  = d.css('.ngg-browser-next').first.attributes['href'].value.split('=').first
				      next_url = "http://timesofcity.com" + domain_url.to_s + "=" + val_id.to_s
				      open_url = Nokogiri::HTML(open(next_url))
				      image_url =  open_url.css('.pic').css('a').first.attributes['href'].value
				      val_id = val_id + 1

				      Post.image_creation(image_url,album)
				    end
				    Post.cron_post_creation(album,posting_type,title,user_id,men_mov_id,men_art_id,c_date)

				elsif domain == "tollywood.net"

					d =  Nokogiri::HTML(open(home_url))
				    title = d.css('.header_rgt')[1].text
				    puts title
					image_count = d.css('.tollywood_lightbox').count
					first_str = home_url.split('Album')[0]
					second_str = home_url.split('Album')[1]
					page_count = 0
					album = Album.create(:album_name => title)
					(0...image_count).each do |page|
						sub_url = first_str + "Photos" + second_str + "/images" + page_count.to_s + ".htm"
						d1 = Nokogiri::HTML(open(sub_url))
						encode_image_url = d1.css('.big_img').css('img').first.attributes['src'].value
						image_url = URI::encode(encode_image_url)
						puts image_url
						page_count = page_count + 1
						Post.image_creation(image_url,album)
					end
					Post.cron_post_creation(album,posting_type,title,user_id,men_mov_id,men_art_id,c_date)

				elsif domain == "www.supergoodmovies.com"

				    d =  Nokogiri::HTML(open(home_url))
				    title = d.css('h1').text.strip.split('(')[0].strip
				    puts title
				    image_count = d.css('.singlemoviegallery_div').css('.gallery_img')
				    album = Album.create(:album_name => title)
				    image_count.each do |page|
				    	sub_url = page.css('a').first.attributes['href'].value
				    	d1 =  Nokogiri::HTML(open(sub_url))
				    	image_url = d1.css('.galleryimage_div').css('img').first.first[1]
				    	puts image_url
				    	Post.image_creation(image_url,album)
				    end
				    Post.cron_post_creation(album,posting_type,title,user_id,men_mov_id,men_art_id,c_date)

				elsif domain == "www.tollytrendz.com"

				    d =  Nokogiri::HTML(open(home_url))
				    title = d.css('h1').text
				    puts title
				    album = Album.create(:album_name => title)
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
					    	Post.image_creation(image_url,album)
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
					    	Post.image_creation(image_url,album)
					    end
				    end
				    Post.cron_post_creation(album,posting_type,title,user_id,men_mov_id,men_art_id,c_date)
				
				elsif domain == "www.kevkeka.com"
					#url = home_url.strip
					t = Nokogiri::HTML(open(home_url))
				    title = t.css('h1').text
				    puts title
				    album = Album.create(:album_name => title)
				    p = t.css('#innermidphg1').css('table').css('table').css('tr')[1].css('td').css('a')
				    for i in 0...p.length
				        begin
				            v = Nokogiri::HTML(open("http://www.kevkeka.com/"+ p[i].attr('href')))
				            image_url = v.css('#innermidphg').css('table').css('tr')[3].css('img').first.first[1]
				            puts image_url
				            Post.image_creation(image_url,album)

				        rescue
				            break
				        end    
				    end
					Post.cron_post_creation(album,posting_type,title,user_id,men_mov_id,men_art_id,c_date)				
				elsif domain == "www.helloandhra.com"
					d = Nokogiri::HTML(open(home_url))
				    title = d.css(".hea-hel").text()
				    puts title
				    album = Album.create(:album_name => title)
				    p = d.css('#galleries_list').css('ul').css('li').css('a')
				    for i in 0...p.length
				        begin
				            v = Nokogiri::HTML(open(p[i].attr('href')))
				           
				            image_url = v.css("table")[4].css('img').first.attr('src')
				            puts image_url
				            Post.image_creation(image_url,album)

				        rescue
				            break
				        end    
				    end    
				    Post.cron_post_creation(album,posting_type,title,user_id,men_mov_id,men_art_id,c_date)	

				end    
				
				at.done = true
				at.save
			rescue
				home_url = at.url
				user_id = at.user_id
				username = User.find(user_id).username
				Sample.album_scrap_failure(username,home_url).deliver!			
			end
		end
	end
end