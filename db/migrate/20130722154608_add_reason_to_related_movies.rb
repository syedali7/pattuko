class AddReasonToRelatedMovies < ActiveRecord::Migration
  def change
    add_column :related_movies, :reason, :string
  end
end
