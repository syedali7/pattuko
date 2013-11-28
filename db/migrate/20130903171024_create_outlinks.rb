class CreateOutlinks < ActiveRecord::Migration
  def change
    create_table :outlinks do |t|
      t.integer :user_id
      t.integer :cuid
      t.string :from_url
      t.string :destination_url
      t.string :type

      t.timestamps
    end
  end
end
