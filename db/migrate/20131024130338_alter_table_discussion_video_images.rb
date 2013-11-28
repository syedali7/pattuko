class AlterTableDiscussionVideoImages < ActiveRecord::Migration
  def change
	rename_column :discussion_video_images,:duscussion_id,:discussion_id
  end
end
