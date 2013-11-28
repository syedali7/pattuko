task :news_scrapping => :environment do
	require 'rubygems'
  	require 'nokogiri'
  	require 'open-uri'

  	home_url = "http://www.nthwall.com/te/n33/2013-09-20/celebritynews/Tollywoodfacesshortageofheroines.php"
    d =  Nokogiri::HTML(open(home_url))

    #d.css('#draggingDisabled0').css('div').first.attributes('style')

    #$('#draggingDisabled0').find('div')[1]

    #d.css('#draggingDisabled0').css('div')[1].text
    news_content = ""

    d.css('table').each do |t|

    	c =  t.attributes['id'].to_s

    	if c.include? "draggingDisabled"
    		#puts c
    		content =  t.css('div')[1].text
			news_content = news_content + content
			
    	end
    end

    t = d.css('.globalcontent-area').css('td').first.text

    puts t

    puts news_content    		
  
end

task :image_scrapping => :environment do

	require 'rubygems'
  	require 'nokogiri'
  	require 'open-uri'

  	home_url = "http://www.nthwall.com/te/cshowall/819210066934682"
    d =  Nokogiri::HTML(open(home_url))

end
task :tupaki_news_scrapping => :environment do
  require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
    #source_name = http://english.tupaki.com/enews/view/Trivikram-suicide-talk-stun-Fans/38621.split('/')[2].split('.')[1]
    #puts source_name
    home_url = "http://english.tupaki.com/enews/view/Trivikram-suicide-talk-stun-Fans/38621"
    d =  Nokogiri::HTML(open(home_url))
    t = d.css("h1 , p").text()
    puts t  
    news = News.create(:content => t, :image_id => 14, :source_name => 'source_name')
    post = Post.create( :title =>'hai' , :posting_id => 1, :description => 'description',
         :posting_type => 'Movie', :postable_type => 'News', :postable_id => news.id , 
          :user_id => 4, :post_to_facebook => 'post_to_facebook' )
    
end

task :all_news_scraping_tupaki => :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  url = "http://www.123telugu.com/category/mnews"
  @source_name = url.split('.')[1]
    #d  = Array.new
    d = Nokogiri::HTML(open(url))
    #puts d
    
    k = d.css(".padding").first.css('ul').css('li').css('a')
    news_url = Array.new
    for i in 0...20
            begin
                news_url[i] = k[i].attr("href")
                puts news_url.count
            rescue Exception => e
                next
            end
           
    end
     #@txt = ''
    news_url.each do|n|
        
        unless News.where(:scrap_url => n).present?
                #puts "success"
        
            unless NewsUrl.where(:news_url => n).present?
                @txt += n + '<br/>'
                NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                      
            end 
        end     
    end    
         #Sample.news_scraping_urls(txt).deliver!
end 
task :all_news_scraping => :environment do
    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
    url = ["http://english.tupaki.com/","http://www.123telugu.com/index.php","http://www.andhraheadlines.com/movies/Default.aspx?tab=2","http://www.manatelugumovies.net/","http://www.chitramala.in/","http://www.supergoodmovies.com/home/index/noindustry/english","http://telugu.way2movies.com/","http://www.greatandhra.com/movies.php","http://www.25cineframes.com/","http://www.teluguone.com/tmdb/","http://www.cinejosh.com/","http://news.searchandhra.com/","http://www.cinegoer.net/telugu-cinema/","http://www.telugucinema.com/c/publish/cat_index_39.php"]
    url.each do |u|
        @source_name = u.split('.')[1]
        #d  = Array.new
        d = Nokogiri::HTML(open(u))
        #begin
            @news_url = []
            @k = Array.new
            if @source_name == "tupaki"
                @k = d.css('.left').first.css('ul').css('li').css('a')
                @k.take(20).each do |n|
                    begin
                        @news_url << n.attr("href")
                    rescue Exception => e
                        next
                    end  
                end
                NewsUrl.newsurls_store(@news_url)
            elsif @source_name == "123telugu"
                k = d.css(".padding").first.css('ul').css('li').css('a')
                    k.take(20).each do |n|
                        begin
                            @news_url << n.attr("href")
                        rescue Exception => e
                            next
                        end                    
                    end
                    NewsUrl.newsurls_store(@news_url)
            elsif @source_name == "andhraheadlines"
                k = d.css('.hpmovietitle')
                    k.take(10).each do |n|
                        begin
                            @news_url << "http://www.andhraheadlines.com/"+n.attr("href")
                        rescue Exception => e
                            next
                        end                    
                    end
                    NewsUrl.newsurls_store(@news_url) 
            elsif @source_name == "manatelugumovies"
               k = d.css('.newscontent').css('ul').css('li').css('a')
                    k.take(10).each do |n|
                        begin
                            @news_url << n.attr("href")
                        rescue Exception => e
                            next
                        end                    
                    end
                    NewsUrl.newsurls_store(@news_url) 
            elsif @source_name == "chitramala"
                k = d.css('#hot-img').css('tbody').css('tr').css('td').css('ul').css('li').css('a')
                k.take(10).each do |n|
                    begin
                        @news_url << "http://www.chitramala.in"+n.attr("href")
                    rescue Exception => e
                        next
                    end                    
                end
                NewsUrl.newsurls_store(@news_url)
            elsif @source_name == "supergoodmovies"
                k = d.css('.latest_updates').css('ul').css('li').css('a')
                k.take(10).each do |n|
                    begin
                        @news_url << n.attr("href")
                    rescue Exception => e
                        next
                    end                    
                end
                NewsUrl.newsurls_store(@news_url)
         
            elsif @source_name == "greatandhra"
                k = d.css('.content').first.css('div').css('div').css('a')
                k.take(10).each do |n|
                    begin
                        @news_url << n.attr("href")
                    rescue Exception => e
                        next
                    end                    
                end
                NewsUrl.newsurls_store(@news_url)
            elsif @source_name == "25cineframes"
                k = d.css('.vertical').first.css('.post-text').css('a')
                k.take(10).each do |n|
                    begin
                        @news_url << n.attr("href")
                    rescue Exception => e
                        next
                    end                    
                end
                NewsUrl.newsurls_store(@news_url)
            elsif @source_name == "teluguone"
               k = d.css('.bullet-list').first.css('li').css('a')
                k.take(10).each do |n|
                    begin
                        @news_url << n.attr("href")
                    rescue Exception => e
                        next
                    end                    
                end
                NewsUrl.newsurls_store(@news_url) 
            elsif @source_name == "cinejosh"
               k = d.css('#latestnews').css('#rlinkcherry').css('li').css('a')
                k.take(10).each do |n|
                    begin
                        @news_url << "http://www.cinejosh.com/"+n.attr("href")
                    rescue Exception => e
                        next
                    end                    
                end
                NewsUrl.newsurls_store(@news_url)
            elsif @source_name == "searchandhra"
               k = d.css('#tabcontent').css('ul').css('li').css('a')
                k.take(20).each do |n|
                    begin
                        news_url << n.attr("href")
                    rescue Exception => e
                        next
                    end                    
                end
                NewsUrl.newsurls_store(@news_url) 
            elsif @source_name == "cinegoer"
               k = d.css('ol').css('li').css('a')
                k.take(10).each do |n|
                    begin
                        @news_url << n.attr("href")
                    rescue Exception => e
                        next
                    end                    
                end 
                NewsUrl.newsurls_store(@news_url)
            elsif @source_name == "telugucinema"
               k = d.css(".summary_title").css('a')
                k.take(10).each do |n|
                    begin
                        @news_url << n.attr("href")
                    rescue Exception => e
                        next
                    end                    
                end 
                NewsUrl.newsurls_store(@news_url)
            end 
        #rescue Exception => e
            #Sample.news_scraping_failure(e.message).deliver!
            #next
        #end    
    end           
end    
=begin
    
rescue Exception => e
    

task :all_news_scraping_urls => :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  #code = ["d.css('.left').first.css('ul').css('li').css('a')","d.css('.padding').first.css('ul').css('li').css('a')","d.css('.hpmovietitle')","d.css('.newscontent').css('ul').css('li').css('a')","d.css('#hot-img').css('tbody').css('tr').css('td').css('ul').css('li').css('a')","d.css('.latest_updates').css('ul').css('li').css('a')","d.css('.newhold').css('table').css('tr').css('td').css('a')","d.css('.content').first.css('div').css('div').css('a')","d.css('.vertical').first.css('.post-text').css('a')","d.css('.bullet-list').first.css('li').css('a')","d.css('#latestnews').css('#rlinkcherry').css('li').css('a')","d.css('.newsblock').first.css('ul').css('li').css('a')","d.css('#tabcontent').css('ul').css('li').css('a')","d.css('ol').css('li').css('a')","d.css('.tit_menor')"]
  url = ["http://english.tupaki.com/","http://www.123telugu.com/","http://www.andhraheadlines.com/movies/Default.aspx?tab=2","http://www.manatelugumovies.net/","http://www.chitramala.in/","http://www.supergoodmovies.com/home/index/noindustry/english","http://telugu.way2movies.com/","http://www.greatandhra.com/movies.php","http://www.25cineframes.com/","http://www.teluguone.com/tmdb/","http://www.cinejosh.com/","http://news.searchandhra.com/","http://www.cinegoer.net/telugu-cinema/","http://www.telugucinema.com/c/publish/cat_index_39.php"]
    for u in 0...url.length
        @source_name = url[u].split('.')[1]
        #d  = Array.new
        d = Nokogiri::HTML(open(url[u]))
        #puts d
        if @source_name == "tupaki"
            k = d.css('.left').first.css('ul').css('li').css('a')
            news_url = Array.new
            for i in 0...20
                news_url[i] = k[i].attr("href")

                puts news_url.count
            end
            @txt = ''
            news_url.each do|n|
                k = n.strip
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += k + '<br/>'
                        NewsUrl.create!(:news_url => k ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!
        elsif @source_name == "123telugu"
            
            k = d.css(".padding").first.css('ul').css('li').css('a')
            news_url = Array.new
            for i in 0...20
                news_url[i] = k[i].attr("href")
                #puts news_url.count
            end
             #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!
        elsif @source_name == "andhraheadlines"
             
            k = d.css('.hpmovietitle')
            @news_url = Array.new
            for i in 0...10
               @news_url[i] ="http://www.andhraheadlines.com/"+k[i].attr("href")
                #puts news_url.count
            end
            NewsUrl.newsurls_store(@news_url) 
            # Sample.news_scraping_urls(txt).deliver!

        elsif @source_name == "manatelugumovies"
              
            k = d.css('.newscontent').css('ul').css('li').css('a')
            news_url = Array.new
            for i in 0...10
               news_url[i] = k[i].attr("href")
               #puts news_url.count
            end
            #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!
        elsif @source_name == "chitramala"
            
            k = d.css('#hot-img').css('tbody').css('tr').css('td').css('ul').css('li').css('a')
            news_url = Array.new
            for i in 0...10
               news_url[i] = "http://www.chitramala.in"+k[i].attr("href")
                #puts news_url.count
            end
            #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!

        elsif @source_name == "supergoodmovies"
            
            k = d.css('.latest_updates').css('ul').css('li').css('a')
            news_url = Array.new
            for i in 0...10
               news_url[i] = k[i].attr("href")
               #puts news_url.count
            end
            #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!

        elsif @source_name == "way2movies"
            
            k = d.css('.newhold').css('table').css('tr').css('td').css('a')
            news_url = Array.new
            require"iconv"
            for i in 0...18
                news_url[i] = news_content = Iconv.conv('ASCII//IGNORE', 'UTF8', k[i].attr("href"))
                 
                #puts news_url.count
            end
             #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!

        elsif @source_name == "greatandhra"
            
            k = d.css('.content').first.css('div').css('div').css('a')
            news_url = Array.new
            for i in 0...15
               news_url[i] = k[i].attr("href")
                #puts news_url.count
            end
            #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!

        elsif @source_name == "25cineframes"
           
            k = d.css('.vertical').first.css('.post-text').css('a')
            news_url = Array.new
            for i in 0...12
               news_url[i] = k[i].attr("href")
               #puts news_url.count
            end
            #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!

        elsif @source_name == "teluguone"
           
            k = d.css('.bullet-list').first.css('li').css('a')
            news_url = Array.new
            for i in 0...10
               news_url[i] = k[i].attr("href")
               #puts news_url.count
            end
            #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!

        elsif @source_name == "cinejosh"
            
            k = d.css('#latestnews').css('#rlinkcherry').css('li').css('a')
            news_url = Array.new
            for i in 0...15
                news_url[i] = "http://www.cinejosh.com/"+k[i].attr("href")
                #puts news_url.count
            end
            #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
            # Sample.news_scraping_urls(txt).deliver!
        elsif @source_name == "searchandhra"
            
            k = d.css('#tabcontent').css('ul').css('li').css('a')
            news_url = Array.new
            for i in 0...15
                news_url[i] = k[i].attr("href")
                #puts news_url.count
            end
             #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
            #Sample.news_scraping_urls(txt).deliver!
        elsif @source_name == "cinegoer"
            
            k = d.css('ol').css('li').css('a')
            news_url = Array.new
            for i in 0...10
                news_url[i] = k[i].attr("href")
                #puts news_url.count
            end
             #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!
        elsif @source_name == "telugucinema"             
               
            k = d.css(".summary_title").css('a')
            news_url = Array.new
            for i in 0...20
                news_url[i] = k[i].attr("href")
                #puts news_url.count
            end
              #@txt = ''
            news_url.each do|n|
                
                unless News.where(:scrap_url => n).present?
                        #puts "success"
                
                    unless NewsUrl.where(:news_url => n).present?
                        @txt += n + '<br/>'
                        NewsUrl.create!(:news_url => n ,:source_name => @source_name)
                                              
                    end 
                end     
            end 
             #Sample.news_scraping_urls(txt).deliver!
                                                     
        end 

    end 
    Sample.news_scraping_urls(@txt).deliver!
end    
=end
task :album_urls_kevkeka => :environment do

  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  
    url = "http://www.kevkeka.com/photogallery.html"

    d = Nokogiri::HTML(open(url))
    k =  d.css('#innermidphg').css('table').css('tr').css('td').css('table').css('tr') 
    
    puts k.length
    c = Array.new
    $i = 1
    while($i<k.length)
        c = k[$i].css('a')
        puts c.length
        #@y = 0
        puts c.length                                                                                                                                                                                           
        #begin
        (0...c.length).each do|f|

            t = Array.new
            url = "http://www.kevkeka.com/"+ c[f].first[1]

    
            unless NewsUrl.where(:album_urls => url).present?
                
                NewsUrl.create!(:album_urls => url ,:status  => "Album")
                                      
            end 
      
        end      
        
       
        $i = $i+3
            
    end

end  


task :album1 => :environment do
    url = "http://www.kevkeka.com/photogallery-1865-1-arrambam-fans-celebrations-at-kasi-theatre.html"
    t = Nokogiri::HTML(open(url))
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
end  

task :movies_a => :environment do
    uart  = ''
    k = Movie.all
    for i in 1..k.length-10
        if Movie.find(k[i]).hero.present? && Movie.find(k[i]).heroine.present? && Movie.find(k[i]).director.present? && Movie.find(k[i]).music_director.present? && Movie.find(k[i]).producer.present? && Movie.find(k[i]).movie_image.present?
            
        else
           p Movie.find(k[i]).id
           uart += Movie.find(k[i]).name+","
        end 
    end
    Sample.news_scraping_urls(uart).deliver!    
end 
task :albums1 => :environment do
   url = "http://www.helloandhra.com/galleries/actors/mahesh-babu-new-pics_5886.html" 
   d = Nokogiri::HTML(open(url))
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
    #Post.cron_post_creation(album,posting_type,title,user_id,men_mov_id,men_art_id,c_date)
end 

task :albums_helloandhra => :environment do
    home_url = ["http://www.helloandhra.com/galleries/movies/","http://www.helloandhra.com/galleries/actors/","http://www.helloandhra.com/galleries/events/","http://www.helloandhra.com/galleries/hot-photos/"]
    for i in 0...home_url.length
        d = Nokogiri::HTML(open(home_url[i]))
        k = d.css("#galleries_list").css('ul').css('li')
        puts k.length
        for i in 0...k.length
            begin
               url = k[i].css('a').first.attr("href")
               puts url
                 unless NewsUrl.where(:album_urls => url).present?
                                
                    NewsUrl.create!(:album_urls => url ,:status  => "Album")
                                          
                end 
            rescue Exception => e
                next
            end
            
        end  
    end      
end 

task :albums_supergood => :environment do
    home_url = ["http://www.supergoodmovies.com/tollywood/movies-gallery-index","http://www.supergoodmovies.com/tollywood/actress-spicy-gallery-index","http://www.supergoodmovies.com/tollywood/actress-models-gallery-index"]
    for i in 0...home_url.length
        d = Nokogiri::HTML(open(home_url[i]))
        k = d.css(".moviegallery_maindiv").css('a')
        puts k.length
        for i in 0...k.length
            begin
                url = k[i].attr("href")
                unless NewsUrl.where(:album_urls => url).present?
                    puts url            
                    NewsUrl.create!(:album_urls => url ,:status  => "Album")
                                          
                end
                  
            rescue Exception => e
                next
            end
        end    
    end
end
task :albums_supergood_actors => :environment do
    home_url = "http://www.supergoodmovies.com/tollywood/actors-gallery-index"
    d = Nokogiri::HTML(open(home_url))
    k = d.css(".moviegallery_maindiv").css('a')
     puts k.length
        for i in 0...k.length
            begin
                puts "success"
                ac_url = k[i].attr("href")
                p = Nokogiri::HTML(open(ac_url))
                u = p.css(".moviegallery_div").first.css('a')
                #puts u.length
                for i in 1..u.length do
                    if i.odd?
                    url = u[i].attr('href')
                    NewsUrl.create!(:album_urls => url ,:status  => "Album")
                    end    
                end    
                
            rescue Exception => e
                next
            end
        end    

end    