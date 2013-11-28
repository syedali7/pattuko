class NewsurlsController < ApplicationController
	def index
		@newsurls = NewsUrl.where("scraped = ? and status is ?", 0,nil).order("id DESC").page(params[:page]).per(20)		
	end
	
	def destroy
   		@newsurls1=NewsUrl.find(params[:id])

   		@newsurls1.delete

   		render layout: false
	end
	def newsurl_delete
		NewsUrl.find(params[:id]).update_attribute("scraped", 1)

   		
		if request.xhr?
		    render :json => {"success"=>true}.to_json
        end
	end

	def show
				
		@albumurls = NewsUrl.where("scraped = ? and status=?", 0,Album).order("id DESC").page(params[:page]).per(20)
	end		
end
