class Event < ActiveRecord::Base
  attr_accessible :name ,:description, :postable_id, :postable_type, :eventable_id, :eventable_type

  extend TireHelper
  include Tire::Model::Search
  include Tire::Model::Callbacks

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_many :albums
end
