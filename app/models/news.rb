class News < ActiveRecord::Base
  attr_accessible :content, :image_id, :source_name, :edited, :scrap_url
  has_many :posts, as: :postable
  belongs_to :image #to get the news image from post


  def self.scrap_sites(url)

  	require 'rubygems'
	  require 'nokogiri'
	  require 'open-uri'
	  @source_name = url.split('.')[1]
	  d = Nokogiri::HTML(open(url))

	  news =  News.where(:source_name => @source_name)
	  #puts news.source_name
	  news_source_name = Array.new
	  for i in 0...news.length
	    news_source_name[i] = news[i].source_name
	  end 

	  return {:document => d, :news => news}
  end

  def self.send_scrap_url_sites(news, k)
  	news_url = Array.new
	  for i in 0...k.length
	    news_url[i] = k[i].attr("href")
	    #puts news_url.count
	  end
    news_url.each do|n|
        for k in (0...news.length) 
          if n === news[k].scrap_url
            puts "success"
            #puts n
            #puts k
            @news_url = ""
          else
            @news_url = n
            #Sample.news_scraping_failure(n).deliver!  
                 
          end
        end
        #puts @news_url
        Sample.news_scraping_urls(@news_url).deliver!  
    end 
	end
end
