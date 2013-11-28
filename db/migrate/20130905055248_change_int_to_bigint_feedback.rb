class ChangeIntToBigintFeedback < ActiveRecord::Migration
  def change
  	change_column :feedbacks, :cuid, :bigint
  end
end
