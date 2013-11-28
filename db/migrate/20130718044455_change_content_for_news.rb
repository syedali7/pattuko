class ChangeContentForNews < ActiveRecord::Migration
  change_table :news do |t|  
        t.change :content, :text 
    end
end
