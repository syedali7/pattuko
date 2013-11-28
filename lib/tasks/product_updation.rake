task :product_updation_scraping => :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

    Product.all.each do |product|
    
        home_url = product.product_url
        domain = home_url.split('.com')[0]

        if domain == "http://www.myntra"

=begin
d =  Nokogiri::HTML(open(home_url))

            title = d.css('.mk-zoom-hide').children.css('h1').text
            puts title

            #if product.title.blank? || product.title.nil?
                product.title = title
            #end

            brand = d.css('.mk-brand-logo').children.css('a').first.attributes['title'].value
            puts brand

            #if product.brand.blank? || product.brand.nil?
                product.brand = brand
            #end

            #pri = d.css('.mk-zoom-hide').children.css('.red').text
            #price = pri.split('.').last.strip
            #price = price.split(' ').first
            #puts price

            pri = d.css('.mk-zoom-hide').children.css('.red')
            price = pri.children.css('meta')[1].attributes['content'].value
            puts price

            #if product.price.blank? || product.price.nil?
                product.price = price
            #end
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

            #if product.size.blank? || product.size.nil?
                product.size = size
            #end

            offer_note = d.css('#fest-pdp-text').text.strip
            puts offer_note

            #if product.offer_note.blank? || product.offer_note.nil?
                product.offer_note = offer_note
            #end

            product.store = "Myntra"

            image_url = d.css('.mk-more-views').children.css('li').first.css('a').first.attributes['href'].value
            puts image_url

            `wget -P public/tmp/product_images/#{product.id} #{image_url}`
            file_name = image_url.split('/').last
            puts file_name
            product.image = File.open(Rails.public_path.to_s + '/tmp/product_images'+ '/' + product.id.to_s + '/' + file_name)
              
            product.save
=end


        elsif domain == "http://www.fashionara"

=begin
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

            product.title = title

            product.brand = brand

            product.offer_note = offer_note

            product.price = price

            product.size = size

            product.store = "Fashionara"


            i = d.css('.more_views').children.css('#thumbs-slide').children.css('li').first.css('a').children.css('img')
                small_image = i.first.attributes['src'].value
            image_url = small_image.sub! 'smallest_', 'medium_'
            puts image_url


            `wget -P public/tmp/product_images/#{product.id} #{image_url}`
            file_name = image_url.split('/').last
            puts file_name
            product.image = File.open(Rails.public_path.to_s + '/tmp/product_images'+ '/' + product.id.to_s + '/' + file_name)
              
            product.save
=end


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


            image_url = d.css('.visible-image-small').children.css('img').first.attributes['src'].value
            puts image_url

            `wget -P public/tmp/product_images/#{product.id} #{image_url}`
            file_name = image_url.split('/').last
            puts file_name
            product.image = File.open(Rails.public_path.to_s + '/tmp/product_images'+ '/' + product.id.to_s + '/' + file_name)

            product.title = title

            product.brand = brand

            product.price = price

            product.size = size

            product.store = "Flipkart"

            product.save

        end
    end    
end


