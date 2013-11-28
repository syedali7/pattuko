class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :artist_id
      t.integer :relation_id
      t.string :relationship_type

      t.timestamps
    end
  end
  def self.down
  	 drop_table :relationships
  end
end
