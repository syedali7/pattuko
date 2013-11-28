class CreateClaps < ActiveRecord::Migration
  def change
    create_table :claps do |t|
    	t.integer :user_id
    	t.belongs_to :clap, polymorphic: true
      	t.timestamps
    end
    add_index :claps, [ :clap_id , :clap_type ]
  end
end
