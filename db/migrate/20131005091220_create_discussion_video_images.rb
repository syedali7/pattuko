class CreateDiscussionVideoImages < ActiveRecord::Migration
  def self.up
    create_table :discussion_video_images do |t|
      t.integer :duscussion_id
      t.integer :message_id
      t.integer :image_id
      t.integer :video_id

      t.timestamps
    end
  end

  def self.down
  	 drop_table :discussion_video_images
  end
end
