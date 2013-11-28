class CuidToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews, :cuid, :bigint
  end
end
