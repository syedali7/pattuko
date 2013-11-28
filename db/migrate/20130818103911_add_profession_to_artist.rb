class AddProfessionToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :profession, :string
  end
end
