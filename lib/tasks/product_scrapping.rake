task :fahionara_product_scraping => :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

  home_url = "http://www.fashionara.com/print-medley-kurta-with-pintucks.html"
  d =  Nokogiri::HTML(open(home_url))   

  p = d.css('.brand-logo')
  brand = p.children.css('img').first.attributes['title'].value
  puts brand

  title = d.children.css('.product-essential').children.css('h1').text
  puts title

  pri = d.css('.price').last.text
  price = pri.split('.').last.strip
  puts price

  offer_note = d.css('.product-offer-note').text
  puts offer_note

  product = Product.create(:title => title, :brand => brand, :price => price, :offer_note => offer_note)

  i = d.css('.more_views').children.css('#thumbs-slide').children.css('li').first.css('a').children.css('img')
  small_image = i.first.attributes['src'].value
  image_url = small_image.sub! 'smallest_', 'medium_'
  puts image_url

  size = ''
  d.css('.size-select-options').css('li').each do |li|
    if li.attributes['class'].value != 'is-disabled-option'
        size = size + li.css('.swatch-title').text
        size = size + ','
    end
  end
  puts size

  #if size[-1] == ','
   # size = size.gsub!(size[-1],'')
  #end

  #puts size


  `wget -P public/tmp/product_images/#{product.id} #{image_url}`
  file_name = image_url.split('/').last
  puts file_name
  product.image = File.open(Rails.public_path + '/tmp/product_images'+ '/' + product.id.to_s + '/' + file_name)
  product.save!

end

task :myntra_product_scraping => :environment do
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	home_url = "http://www.myntra.com/shirts/us-polo-assn/us-polo-assn-men-olive-green-casual-shirt/161565/buy"
  	d =  Nokogiri::HTML(open(home_url))

    title = d.css('.mk-zoom-hide').children.css('h1').text
    puts title

  	brand = d.css('.mk-brand-logo').children.css('a').first.attributes['title'].value
  	puts brand

  	#pri = d.css('.mk-zoom-hide').children.css('.red').text
  	#price = pri.split('.').last.strip
  	#price = price.split(' ').first
  	#puts price


    #$($('.red','.mk-zoom-hide').find('meta')[1]).attr('content')

    pri = d.css('.mk-zoom-hide').children.css('.red')
    price = pri.children.css('meta')[1].attributes['content'].value
    puts price


  	offer_note = d.css('#fest-pdp-text').text.strip
  	puts offer_note

    size = ''

    #d.css('.options').css('button').each do |b|
     # unless b.text.include? '\r\n'
      #  size = size + b.text
       # size = size + ','
     # end
    #end

    d.css('.options').css('button').each do |b|
      if b.attributes['data-count'].value != '0'
        size = size + b.text
        size = size + ','
      end
    end


    puts size

  	image = d.css('.mk-more-views').children.css('li').first.css('a').first.attributes['href'].value
  	puts image

    `wget -P public/tmp/product_images/test #{image}`

end

task :jabong_product_scraping => :environment do
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'

	home_url = "http://www.jabong.com/tog-Checks-White-Casual-Shirt-322345.html"
	d =  Nokogiri::HTML(open(home_url))

	title = d.css('#qa-title-product').text
	puts title

  brand = d.css('#qa-prd-brand').text
  puts brand

	pri = d.css('#before_price').text
	price = pri.split('.').last.strip
	puts price

  image = d.css('.pdp-thumbview').css('ul').css('li').first.attributes['data-image-product'].value
  puts image

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

  puts size

end

task :flipkart_product_scraping => :environment do
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	home_url = "http://www.flipkart.com/park-avenue-men-s-striped-formal-shirt/p/itmdhdfuybdytydg?pid=SHTDHDFKADQZNQZU&icmpid=reco_pp_same_shirt_5"
	d =  Nokogiri::HTML(open(home_url))

  title = d.css('#topsection').children.css('h1').first.attributes['title'].value
  puts title

  brand = title.split(' ')[0]

	price = d.css('.prices').children.css('meta').first.attributes['content'].value
	puts price

  image_url = d.css('.visible-image-small').children.css('img').first.attributes['src'].value
  puts image_url

  size = ''

  d.css('.sectionImage')[1].css('a').each do |a|
    size = size + a.css('.multiselect').text
    size = size + ','
  end
  puts size

end


