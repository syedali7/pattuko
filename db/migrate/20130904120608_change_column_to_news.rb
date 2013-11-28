class ChangeColumnToNews < ActiveRecord::Migration
  def change
  	rename_column :news, :source, :source_name
  end
end

