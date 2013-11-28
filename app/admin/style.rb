ActiveAdmin.register Style do
	menu :if => proc{ current_admin_user.role == 'admin' }
	controller do 
		def create 
			Style.runtask
		end
	end

	form do |f|
	    f.inputs 'New Style' do 
	    	f.input :title
	    	telugu_movies = Movie.where(:wood_id => 1)
	  		f.input :movie_id , :label => 'Movie Name', :as => :select,
	  			:collection => telugu_movies.where( "year > ?" ,2012).all.map{|u| [u.name, u.id]}
	  		f.input :artist_id , :label => 'Artist Name', :as => :select,
	  			:collection => Artist.all.map{|u| [u.name, u.id]}
		    f.input :image, :as => :file
			f.has_many :products do |p|
	          p.input :product_url, :label => 'Product' 
	          p.input :_destroy, :as => :boolean
	        end

	    end
	    f.buttons
	end

	controller do

	    def create
	     	require 'rubygems'
			require 'nokogiri'
			require 'open-uri'

			style = params[:style]

			product_urls = params[:style][:products_attributes]

			style = Style.create(:title => params[:style][:title], :image => params[:style][:image],
								:movie_id => params[:style][:movie_id], :artist_id => params[:style][:artist_id] )

			#product_url = Array.new

			#product_url = params[:products_attributes]

			product_urls.each do |key,value|

				product_url = value['product_url']
				puts product_url
				
				home_url = product_url

				domain = home_url.split('.com')[0]

				if domain == "http://www.fashionara"

					d =  Nokogiri::HTML(open(home_url))

					b = d.css('.brand-logo')
					brand = b.children.css('img').first.attributes['title'].value
					puts brand

					title = d.children.css('.product-essential').children.css('h1').text
					puts title

					pri = d.css('.price').last.text
					price = pri.split('.').last.strip
					puts price

					offer_note = d.css('.product-offer-note').text
					puts offer_note

					size = ''
					
					d.css('.size-select-options').css('li').each do |li|
					    if li.attributes['class'].value != 'is-disabled-option'
					        size = size + li.css('.swatch-title').text
					        size = size + ','
					    end
					end

					if size[-1] == ','
				  		size[-1] = ''
				  	end

				  	if size[0] == ','
				  		size[0] = ''
				  	end

					puts size

					product = Product.create(:title => title, :brand => brand, :price => price, :offer_note => offer_note,
						:style_id => style.id, :product_url => product_url, :size => size, :store => "Fashionara")

					i = d.css('.more_views').children.css('#thumbs-slide').children.css('li').first.css('a').children.css('img')
						small_image = i.first.attributes['src'].value
					image_url = small_image.sub! 'smallest_', 'medium_'
					puts image_url


					`wget -P public/tmp/product_images/#{product.id} #{image_url}`
					file_name = image_url.split('/').last
					puts file_name
					product.image = File.open(Rails.public_path.to_s + '/tmp/product_images'+ '/' + product.id.to_s + '/' + file_name)
					  
					product.save

				elsif domain == "http://www.myntra"

					#begin

						d =  Nokogiri::HTML(open(home_url))

						title = d.css('.mk-zoom-hide').children.css('h1').text
	    				puts title

					  	bd = d.css('.mk-brand-logo').children.css('a').first
					  	unless bd.nil? 
					  		brand = bd.attributes['title'].value
					  	else
					  		brand = 'Brand not specified'
					  	end
					  	puts brand

					  	pri = d.css('.mk-zoom-hide').children.css('.red')
			            price = pri.children.css('meta')[1].attributes['content'].value
			            puts price

					  	size = ''

					    d.css('.options').css('button').each do |b|
			              if b.attributes['data-count'].value != '0'
			                size = size + b.text
			                size = size + ','
			              end
			            end

					    if size[-1] == ','
					  		size[-1] = ''
					  	end

					  	if size[0] == ','
					  		size[0] = ''
					  	end

					    puts size

					  	offer_note = d.css('#fest-pdp-text').text.strip
					  	puts offer_note


					  	product = Product.create(:title => title, :brand => brand, :price => price, :offer_note => offer_note,
							:style_id => style.id, :product_url => product_url, :size => size, :store => "Myntra")

					  	image_url = d.css('.mk-more-views').children.css('li').first.css('a').first.attributes['href'].value
					  	puts image_url

					  	`wget -P public/tmp/product_images/#{product.id} #{image_url}`
						file_name = image_url.split('/').last
						puts file_name
						product.image = File.open(Rails.public_path.to_s + '/tmp/product_images'+ '/' + product.id.to_s + '/' + file_name)
						  
						product.save
					#rescue
					#end

				elsif domain == "http://www.flipkart"

					d =  Nokogiri::HTML(open(home_url))

				  	title = d.css('#topsection').children.css('h1').first.attributes['title'].value
				  	puts title

				  	brand = title.split(' ')[0]

					price = d.css('.prices').children.css('meta').first.attributes['content'].value
					puts price

				  	size = ''

				  	d.css('.sectionImage')[1].css('a').each do |a|
				    	size = size + a.css('.multiselect').text
				    	size = size + ','
				  	end
				  	puts size

				  	if size[-1] == ','
				  		size[-1] = ''
				  	end

				  	if size[0] == ','
				  		size[0] = ''
				  	end

				  	product = Product.create(:title => title, :brand => brand, :price => price,
							:style_id => style.id, :product_url => product_url, :size => size, :store => "Flipkart")

				  	image_url = d.css('.visible-image-small').children.css('img').first.attributes['src'].value
				 	puts image_url

				 	`wget -P public/tmp/product_images/#{product.id} #{image_url}`
					file_name = image_url.split('/').last
					puts file_name
					product.image = File.open(Rails.public_path.to_s + '/tmp/product_images'+ '/' + product.id.to_s + '/' + file_name)

					product.save


				elsif domain == "http://www.jabong"

					d =  Nokogiri::HTML(open(home_url))

					title = d.css('#qa-title-product').text
					puts title

					pri = d.css('#before_price').text
				  	price = pri.split('.').last.strip
				  	puts price

				  	size = ''

				  	d.css('#OptionsSingleDefault').children.css('li').each do |l|
					    a = l.attributes['onclick'].value
					    main = a.split('_gaq')[0]
					    av = main.split(',')[0]
					    avail = av.split('Evt')[1]

					    if avail == "('sizeAvailable'"
					      s = main.split(',')[1]
					      si = s.split(');')[0]
					      size = size + si.delete("^a-zA-Z0-9")
					      size = size + ','
					    end
					end

					if size[-1] == ','
				  		size[-1] = ''
				  	end

				  	if size[0] == ','
				  		size[0] = ''
				  	end

					puts size

				  	product = Product.create(:title => title, :price => price, :size => size, :style_id => style.id,
				  		:store => 'Jabong')

=begin
					image_url = d.css('.pdp-thumbview').children.css('li').first.attributes['data-image-product'].value
				  	puts image_url

				  	`wget -P public/tmp/product_images/#{product.id} #{image_url}`
					file_name = image_url.split('/').last
					puts file_name
					product.image = File.open(Rails.public_path.to_s + '/tmp/product_images'+ '/' + product.id.to_s + '/' + file_name)
					  
					product.save
=end


				end

			end
			
			
			redirect_to admin_style_path(style)
	    end
	end

	show do
      render 'style_show'
  	end


end

