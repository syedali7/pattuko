class ChangeDateForFeed < ActiveRecord::Migration
  def up
  	change_column :feeds, :post_created_on, :datetime
  end

  def down
  	change_column :feeds, :post_created_on, :date
  end
end
