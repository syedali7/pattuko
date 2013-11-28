module ApplicationHelper
	def pageless(total_pages, params, url, container=nil)
        opts = {
            :totalPages => total_pages,
            :url => url,
            :loaderMsg => 'Loading more results',
            :distance => 240,
            :loaderImage => image_tag('load.gif')
        }

        container && opts[:container] ||= container

        javascript_tag("$('" + params[:element] + "').pageless(#{opts.to_json});")
    
    end

  def cache_key_for(models)
    "#{models.count}-{models.map(&:updated_at).max.utc.to_s(:number)}"
end
end
