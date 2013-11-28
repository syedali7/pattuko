class AddProductUrlToProduct < ActiveRecord::Migration
  def change
    add_column :products, :product_url, :string
  end
end
