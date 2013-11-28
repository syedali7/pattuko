class AddSourceToNews < ActiveRecord::Migration
  def change
    add_column :news, :source, :string
  end
end
