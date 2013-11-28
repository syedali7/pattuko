class PopulateViewBlocks < ActiveRecord::Migration
  def self.up
  	  ViewBlock.create(:name=>"TopStories",:identifier=>'B1',:content=>"render :partial=>'view_blocks/top_stories', :locals=>{:post=>Post.where('trusted=?',true)}")
  	  ViewBlock.create(:name=>"Trending",:identifier=>'B3',:content=>"render :partial=>'view_blocks/trending', :locals=>{:post=>Post.where('trending=?',true)}")
  	  ViewBlock.create(:name=>"FanSuggestion",:identifier=>'B2',:content=>"render :partial=>'view_blocks/fan_suggestion'")
  	  ViewBlock.create(:name=>"ImageGallery",:identifier=>'B2',:content=>"render :partial=>'view_blocks/album',:locals =>{:post=>Post.find_by_trending_and_postable_type(true,'Album')}")
  end

  def self.down
  	  ViewBlock.delete_all
  end
end
