class AddWeightToArtistProfessions < ActiveRecord::Migration
  def change
    add_column :artist_professions, :weight, :integer
  end
end
