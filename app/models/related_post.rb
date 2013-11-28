class RelatedPost < ActiveRecord::Base
  attr_accessible :post_id, :related_post_id, :weight
  belongs_to :post

  belongs_to :related_post, :class_name => 'Post', :foreign_key => :related_post_id

  default_scope order('post_id DESC')

  after_touch() { tire.update_index }

  self.include_root_in_json = false

  extend TireHelper
  include Tire::Model::Search
  include Tire::Model::Callbacks

	# we dont need mapping because we dont have any indexed columns
  mapping do
    indexes :id, :index => :not_analyzed
    indexes :post_id, :index => :not_analyzed

    indexes :related_post do
    	indexes :id, :index => :not_analyzed
    	indexes :title, :index => :not_analyzed
    	indexes :image_url_thumb, :index => :not_analyzed
    	indexes :image_thumb_height, :index => :not_analyzed
	end
  end

  def to_indexed_json
    to_json(
      include: { 
        related_post: {only: [:id, :title], methods: [:image_url_thumb, :image_thumb_height]}
      } 
    )
  end

  
end
