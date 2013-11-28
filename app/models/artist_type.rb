class ArtistType < ActiveRecord::Base
  attr_accessible :name, :priority, :points

  has_many :movie_artists
  has_many :artists, :through => :movie_artists

  has_many :movies, :through => :movie_artists

  accepts_nested_attributes_for :artists

  self.includes(:artists)
  self.includes(:movies)
  self.includes(:movie_artists)
end
