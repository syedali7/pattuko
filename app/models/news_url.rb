class NewsUrl < ActiveRecord::Base
	attr_accessible :news_url, :source_name, :artist_id, :movie_id, :scraped , :image_url, :album_urls, :status

	after_create :update_souce_name

	def update_souce_name
    self.source_name = self.news_url.split('.')[1]
    self.source_name = self.news_url.split('.')[0] if self.source_name ==  "com"
    self.save
 	end

  def update_title_content
    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'

    d = Nokogiri::HTML(open(self.news_url.strip))

    ret_val = {}
    if self.source_name == "tupaki"
      ret_val[:news_content] = d.css("h1 , p").text()
      ret_val[:title] = d.css("h1").last().text()

    elsif self.source_name == "nthwall"

      ret_val[:news_content] = d.css('#draggingDisabled0').text().strip + d.css('#draggingDisabled1').text().strip
      ret_val[:title] = d.css('.globalcontent-area').css('td').first.text()

    elsif self.source_name == "andhraheadlines"

      ret_val[:news_content] = d.css("#body_lblArticle").text()
      ret_val[:title] = d.css("#body_lblTitle").text()

    elsif self.source_name == "manatelugumovies"
      
      ret_val[:news_content] = d.css(".content").text()
      ret_val[:title] = d.css("h2 , .selectorgadget_selected")[0].text()

    elsif self.source_name == "chitramala"  

      ret_val[:news_content] = d.css(".atv_division ,.selectorgadget_rejected").text()
      ret_val[:title] = d.css(".bluTitle1").text()

    elsif self.source_name == "supergoodmovies"

      ret_val[:news_content] = d.css(".details_text").text()
      ret_val[:title] = d.css(".fs20").text() 

    elsif self.source_name == "way2movies"

      ret_val[:news_content] = d.css(".matt").text()
      ret_val[:title] = d.css(".display-head").children.css("h2").text()

    elsif self.source_name == "greatandhra"

      ret_val[:news_content] = d.css("p").text()
      ret_val[:title] = d.css(".color_15").text()

    elsif self.source_name == "25cineframes"
     
      ret_val[:news_content]= d.css("p").text()
      ret_val[:title] = d.css("h1").last.text()

    elsif self.source_name == "123telugu"

      ret_val[:news_content] = d.css("p").text()
      ret_val[:title] = d.css(".contentheading").text().strip

    elsif self.source_name == "idlebrain"

      ret_val[:news_content] = d.css("font")[3].text()
      ret_val[:title] = d.css("font")[0].text()

    elsif self.source_name == "indiaglitz"
      
      ret_val[:news_content] = d.css(".black").css('p').text()
      ret_val[:title] =  d.css("h2").first.text()

    elsif self.source_name == "teluguone"

      ret_val[:news_content] = d.css('.celebrity-details-description-txt').css('p').text()
      ret_val[:title] = d.css('.movie-details-title').first.text().strip

    elsif self.source_name == "cinejosh"
      
      ret_val[:news_content] = d.css('.newstext').text().strip
      ret_val[:title] = d.css('h1').text().strip

    elsif self.source_name == "tollywoodandhra"
      
      ret_val[:news_content] = d.css('.content').css('p').text()
      ret_val[:title] = d.css('h2').first.text()

    elsif self.source_name == "searchandhra"
      
      ret_val[:news_content] = d.css('#post').css('p').text()
      ret_val[:title] = d.css('.entry-title').text()

    elsif self.source_name == "cinegoer"

      ret_val[:news_content] = d.css('.rightTxt2').text().strip
      ret_val[:title] = d.css('h3').text()

    elsif self.source_name == "telugucinema"

      ret_val[:news_content] = d.css('.article_text')[2].text().strip
      ret_val[:title] = d.css('.article_title')[0].text().strip
                          
    end

    ret_val[:news_content] = ret_val[:news_content].encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
    ret_val[:title] = ret_val[:title].gsub("'", '').encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")

    return ret_val

  end
  
  def self.newsurls_store(news_url)
    
    news_url.each do|n|
      k = n.strip
      unless NewsUrl.where(:news_url => n).present?
          NewsUrl.create!(:news_url => k)                                    
      end  
    end
    Sample.news_scraping_urls(news_url).deliver!
  end  
end
