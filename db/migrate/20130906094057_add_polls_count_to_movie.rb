class AddPollsCountToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :polls_count, :integer
  end
end
