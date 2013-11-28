class AddScoreToUser < ActiveRecord::Migration
  def change
    add_column :users, :score, :integer, :default => 10
  end
end
