class OutlinksController < ApplicationController
	def index
		dest_url = params[:dest_url]
		outlinks = Outlink.create(:destination_url => dest_url, :from_url => request.env["HTTP_REFERER"], :source_type => 'shop' )
		if current_user
			outlinks.user_id = current_user.id
		else
			outlinks.cuid = session[:cuid]
		end
		outlinks.save

		redirect_to dest_url
	end
end
