task :news_movie_name_edit => :environment do
	News.where("id >= 2190", :edited => nil).each do |news|
		puts news.id
		content = news.content
		unless content.nil?
			Movie.where("id <= 4530", :wood_id => 1 ).each do |movie|
				if content.include?movie.name
					html_text = "<a href='/movies/" + movie.slug + "'>" + movie.name + "</a>"
					new_content = news.content.sub " " + movie.name + " ", " " + html_text + " "

					news.content = new_content
					news.save!
				end
			end
		end
	end
end

task :news_artist_name_edit => :environment do
	News.where("id >= 2170").each do |news|
		puts news.id
		content = news.content
		artist_flag = false
		unless content.nil?
			Artist.all.each do |artist|
				puts artist.id
				if content.include?artist.name
					artist_flag = true
					Artist.where("name like ?", "%#{artist.name}%").each do |artist|
						if content.include?artist.name
							html_text = "<a href='/artists/" + artist.slug + "'>" + artist.name + "</a>"
							new_content = news.content.sub " " + artist.name + " ", " " + html_text + " "
							news.content = new_content
							news.save!
							artist_flag = false
							break
						end
					end
					if artist_flag == true
						html_text = "<a href='/artists/" + artist.slug + "'>" + artist.name + "</a>"
						new_content = news.content.sub " " + artist.name + " ", " " + html_text + " "
						news.content = new_content
						news.save!
					end
				end
			end
		end
	end
end