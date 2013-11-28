class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.integer :cuid
      t.text :feedback

      t.timestamps
    end
  end
end
