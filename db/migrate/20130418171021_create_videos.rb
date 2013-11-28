class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :youtube_url
      t.string :youtube_code
      t.timestamps
    end
  end
end
