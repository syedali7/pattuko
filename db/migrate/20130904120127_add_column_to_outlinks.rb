class AddColumnToOutlinks < ActiveRecord::Migration
  def change
  	add_column :outlinks, :source, :string
  end
end
