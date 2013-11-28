class CreateArtistProfessions < ActiveRecord::Migration
  def change
    create_table :artist_professions do |t|
      t.integer :artist_id
      t.integer :artist_type_id
      t.string :profession

      t.timestamps
    end
  end
end
