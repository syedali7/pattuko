class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :analysis
      t.string :punchline

      t.timestamps
    end
  end
end
