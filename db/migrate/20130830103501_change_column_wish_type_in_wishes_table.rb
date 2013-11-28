class ChangeColumnWishTypeInWishesTable < ActiveRecord::Migration
  def change
  	change_column :wishes,:wish_type,:string
  end
end
