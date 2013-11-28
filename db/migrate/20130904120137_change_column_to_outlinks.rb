class ChangeColumnToOutlinks < ActiveRecord::Migration
  def change
  	rename_column :outlinks, :source, :source_type
  end
end
