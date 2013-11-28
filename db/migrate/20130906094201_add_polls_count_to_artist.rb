class AddPollsCountToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :polls_count, :integer
  end
end
