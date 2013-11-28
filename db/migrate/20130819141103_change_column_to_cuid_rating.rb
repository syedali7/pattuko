class ChangeColumnToCuidRating < ActiveRecord::Migration
  def change
  	change_column :ratings, :cuid, :bigint
  end
end
