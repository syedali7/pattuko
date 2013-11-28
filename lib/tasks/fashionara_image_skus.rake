task :image_folders => :environment do
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'csv'
	url = "http://182.72.219.38:9980"
	doc = Nokogiri::HTML(open(url))
	# for all brands doc.css('tr')[2..-2]
	brand_tr = 0
	folder_id = 11061
	doc.css('tr')[128..-2].each do |brand_dir|
		brand = brand_dir.css('td').children[1].attributes['href'].value
		brand_url = url + '/' + brand
		brand_doc = Nokogiri::HTML(open(brand_url.gsub(' ', '%20')))
		unless brand_doc.nil?
			#for all skus brand_doc.css('tr')[3..-2]
			sku_tr = 0
			brand_doc.css('tr')[3..-2].each do |sku_dir|
				sku = sku_dir.css('td').children[1].attributes['href'].value
				sku_text = sku_dir.css('td').css('a').text.gsub('/', '')
				sku_url = brand_url + sku
				sku_doc = Nokogiri::HTML(open(sku_url.gsub(' ', '%20')))
				unless sku_doc.nil?
					unless sku_doc.css('tr')[3..-2].nil?	
						dirs = sku_doc.css('tr')[3..-2].count 
						if dirs == 2 
							sku_doc.css('tr')[3..-2].each do |sku_folder|
								folder_href = sku_folder.css('td').children[1].attributes['href'].value
								folder_url = sku_url + folder_href
								unless folder_url.include?('.jpg')
									item_doc = Nokogiri::HTML(open(folder_url.gsub(' ', '%20')))
									if folder_href.downcase.include?('without')
										unless item_doc.css('tr')[4..-2].nil?
											item_doc.css('tr')[4..-2].each do |item_tr|
												item_href = item_tr.css('td').children[1].attributes['href'].value
												image_url = folder_url + item_href
												file = image_url.split('/').last
												begin 
													li = WithoutLogoImage.where(:brand => brand, :sku => sku_text, :image_url => image_url, :file => file ).first
													if li.nil?
														WithoutLogoImage.create(:brand => brand, :sku => sku_text, :folder_id => folder_id, :image_url => image_url, :file => file )
													end
												rescue
													next
												end
											end
											end
									else
										unless item_doc.css('tr')[4..-2].nil?
											item_doc.css('tr')[4..-2].each do |item_tr|
												item_href = item_tr.css('td').children[1].attributes['href'].value
												image_url = folder_url + item_href
												file = image_url.split('/').last
												begin
													li = WithLogoImage.where(:brand => brand, :sku => sku_text, :image_url => image_url, :file => file).first
													if li.nil?
														WithLogoImage.create(:brand => brand, :sku => sku_text, :folder_id => folder_id, :image_url => image_url, :file => file )
													end
												rescue
													next
												end
											end
										end
									end
								end
								puts brand
								puts 'done with brand :' + brand_tr.to_s + ' sku : ' + sku_tr.to_s + 'folder :' + folder_id.to_s
								
							end
						end
					end
				end
				folder_id += 1
				sku_tr += 1
			end
		end
		brand_tr += 1
	end
end
	
task:all_images => :environment do 
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'csv'
	url = "http://182.72.219.38:9980"
	doc = Nokogiri::HTML(open(url))
	brand_tr = 0
	doc.css('tr')[65..-2].each do |brand_dir|
		brand_link = brand_dir.css('td').children[1].attributes['href'].value.gsub('/', '')
		brand_url = url + '/' + brand_link
		brand_doc = Nokogiri::HTML(open(brand_url.gsub(' ', '%20')))
		unless brand_doc.nil?
			#for all skus brand_doc.css('tr')[3..-2]
			brand_doc.css('tr')[3..-2].each do |dir_1|
				link_1 = dir_1.css('td').children[1].attributes['href'].value.gsub('/', '')
				url_1 = brand_url + '/' + link_1
				if url_1.include?('.jpg')
					AllImage.create(:file => link_1, :url => url_1, :brand => brand_link)
				else
					doc_1 = Nokogiri::HTML(open(url_1.gsub(' ', '%20')))
					unless doc_1.nil?
						unless doc_1.css('tr')[3..-2].nil?
							doc_1.css('tr')[3..-2].each do |dir_2|
								link_2 = dir_2.css('td').children[1].attributes['href'].value.gsub('/', '')
								url_2 = url_1 + '/' + link_2
								if url_2.include?('.jpg')
									AllImage.create(:file => link_2, :url => url_2,  :brand => brand_link)
								else
									doc_2 = Nokogiri::HTML(open(url_2.gsub(' ', '%20')))
									unless doc_2.nil?
										unless doc_2.css('tr')[3..-2].nil?
											doc_2.css('tr')[3..-2].each do |dir_3|
												link_3 = dir_3.css('td').children[1].attributes['href'].value.gsub('/', '')
												url_3 = url_2 + '/' + link_3
												if url_3.include?('.jpg')
													AllImage.create(:file => link_3, :url => url_3,  :brand => brand_link)
												else
													doc_3 = Nokogiri::HTML(open(url_3.gsub(' ', '%20')))
													unless doc_3.nil?
														unless doc_3.css('tr')[3..-2].nil?
															doc_3.css('tr')[3..-2].each do |dir_4|
																link_4 = dir_4.css('td').children[1].attributes['href'].value.gsub('/', '')
																url_4 = url_3 + '/' + link_4
																if url_4.include?('.jpg')
																	AllImage.create(:file => link_4, :url => url_4,  :brand => brand_link)
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
				puts 'Done with ' + brand_link + ' and row ' + brand_tr.to_s
			end
		end
		brand_tr += 1
	end
end


task :find_brand_row => :environment do 
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'csv'
	url = "http://182.72.219.38:9980"
	doc = Nokogiri::HTML(open(url))
	brand_tr = 0
	doc.css('tr')[3..-2].each do |brand_dir|
		brand_link = brand_dir.css('td').children[1].attributes['href'].value.gsub('/', '')
		puts 'Done with ' + brand_link + ' and row ' + brand_tr.to_s
		brand_tr += 1
	end
end