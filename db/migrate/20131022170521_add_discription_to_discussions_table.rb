class AddDiscriptionToDiscussionsTable < ActiveRecord::Migration

  def self.up
	add_column :discussions,:discription,:string,:default=>"no discription given........"
  end

  def self.down
	remove_column :discussions,:discription
  end

end
