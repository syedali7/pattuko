class AddMentionsCountToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :mentions_count, :integer
  end
end
