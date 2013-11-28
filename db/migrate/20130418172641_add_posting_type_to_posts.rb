class AddPostingTypeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :posting_type, :string
  end
end
