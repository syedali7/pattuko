class AddProductUrlToStyle < ActiveRecord::Migration
  def change
    add_column :styles, :product_url, :string
  end
end
