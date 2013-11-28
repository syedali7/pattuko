task :photo_migration => :environment do
	Post.all.each do |p|
		images = []
		if p.postable_type == "News"
			news = News.where(:id => p.postable_id).first
			unless news.nil?
				images = images + Image.where(:id => news.image_id)
			end
		elsif p.postable_type == "Album"
			image_ids = AlbumImage.where(:album_id => p.postable_id).collect(&:image_id)
			image_ids.each do |i|
				images = images + Image.where(:id => i)
			end
		elsif p.postable_type == "Image"
			images = images + Image.where(:id => p.postable_id)
		end
		key = (p.posting_type.downcase + "_id").to_sym
		unless images.empty?
			images.each do |i|
				puts i
				Photo.create(:image_id => i.id, key => p.posting_id)
			end
		end
	end
end