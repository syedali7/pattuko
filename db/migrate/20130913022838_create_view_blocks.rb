class CreateViewBlocks < ActiveRecord::Migration
  def change
    create_table :view_blocks do |t|
      t.string :name
      t.string :identifier
      t.text :content

      t.timestamps
    end
  end
end
