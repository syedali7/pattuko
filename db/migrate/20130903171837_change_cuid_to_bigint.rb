class ChangeCuidToBigint < ActiveRecord::Migration
  def change
  	change_column :outlinks, :cuid, :bigint
  end
end
