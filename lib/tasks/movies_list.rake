task :list_of_movies => :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

  (0...59).each do |page|
  # home_url = 'http://www.imdb.com/search/title?countries=in&sort=moviemeter,asc&start=' + ((page * 50) + 1).to_s
    home_url = "http://www.imdb.com/search/title?at=0&languages=te&sort=moviemeter,asc&start=" + ((page * 50) + 1).to_s
    d =  Nokogiri::HTML(open(home_url))
    d.css('.results').children.css('tr')[1..-1].each_with_index do |movie, index|
      if page <= 0 && index <= -1
        next
      end
      href = movie.css('.title').css('a').first.attributes['href'].value
      puts href
      url = "http://www.imdb.com" + href + "fullcredits"
      puts url

      docs =  Nokogiri::HTML(open(url))

      title = docs.css('.main').text

      puts title

      year =  docs.css('h1').css('span').text.split(')').first.gsub('(', '').to_s

      puts year

      movie = Movie.where(:name => title, :year => year).first

      if movie.nil?
        movie = Movie.create(:name => title, :year => year , :wood_id => 1 )
        puts 'movie created'
      end

      i = 0
      docs.css('#tn15content table')[1...-2].each do |table|
        a_type = table.css('tr').first.css('h5').text
        artist_type = ArtistType.where(:name => a_type).first
        if artist_type.nil?
          artist_type =  ArtistType.create(:name => a_type)
          puts 'type created'
        end
        if i == 2
          table.css('tr').each do |tr|
            a_name =  tr.css('.nm').text
            artist = Artist.where(:name => a_name).first
            if artist.nil?
              artist = Artist.create(:name => a_name )
              puts 'artist created'
            end
            MovieArtist.create(:movie_id => movie.id, :artist_id => artist.id, :artist_type_id => artist_type.id)
          end
        else
            table.css('tr')[1..-1].each do |tr|
              a_name =  tr.css('td').first.css('a').text
              puts 'td'
              artist = Artist.where(:name => a_name).first
              if artist.nil?
                artist = Artist.create(:name => a_name )
                puts 'artist created'
              end
              MovieArtist.create(:movie_id => movie.id, :artist_id => artist.id, :artist_type_id => artist_type.id)
              puts 'done'
            end
        end
        i = i +1
      end
      puts "page #{page.to_s} movie #{index.to_s } completed"
    end
  end
end