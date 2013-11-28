task :related_posts_weight => :environment do 
	RelatedPost.where("id > ?", 157400).each do |rp|
		#to reset the weight
		rp.weight = 0
		rp.save!
		begin
			puts rp.id
			post = Post.find(rp.related_post_id)

			#for trending weight 150
			if post.trending?
				weight = 150
				rp.weight += weight
				rp.save
				puts "Weight added for trending #{rp.id}"
			end

			#for trusted weight 100
			if post.trusted?
				weight = 100
				rp.weight += weight
				rp.save
				puts "Weight added for trusted #{rp.id}"
			end

			#for total views weight watches * 2
			watches = post.total_views
			weight = watches * 2
			rp.weight += weight
			rp.save
			puts "Weight added for watches #{rp.id}"

			#for post created at weight 
			if post.created_at > (Time.now - 2.weeks)
				if post.created_at > (Time.now - 1.week)
					if post.created_at > (Time.now - 5.days)
						if post.created_at > (Time.now - 2.day)
							rp.weight += 100
							rp.save	
						else
							rp.weight += 50
							rp.save	
						end
					else
						rp.weight += 40
						rp.save	
					end
				else
					rp.weight += 30
					rp.save	
				end
			end
		rescue
			puts "error occured at #{rp.id}"
		end
	end
end