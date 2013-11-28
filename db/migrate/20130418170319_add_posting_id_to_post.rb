class AddPostingIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :posting_id, :integer
  end
end
