class AddReleaseDateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :release_date, :date
  end
end
