class AddMentionsCountToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :mentions_count, :integer
  end
end
