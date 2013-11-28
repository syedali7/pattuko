ActiveAdmin.register Relationship do
 #form :partial => "form"
 config.per_page = 3

 index do
 	table_for Relationship.order("created_at desc").page(params[:page]).per(10) do
	    column "Artist",:id  do |r| 
	    	r.artist.name 
	    end
	    column "Relative",:id do |r|
	        r.relative.name 
	    end
	    column "Relationship Name",:id do|r| 
	    	r.relationship_type 
	    end
	    default_actions
  	end
 end


 action_item :only => [:index] do
    link_to('new_relation', new_relation_admin_relationships_path)
 end


 collection_action :new_relation,:method=>:get do
 	@relationship=Relationship.new
 end

 collection_action :create_relation,:method=>:post do
    @relation=Relationship.create(:artist_id=>params[:artist_id],:relation_id=>params[:relation_id],:relationship_type=>params[:relationship_type])
    if params[:relationship_back].present?
    	@rev_relation=Relationship.create(:artist_id=>params[:relation_id],:relation_id=>params[:artist_id],:relationship_type=>params[:relationship_back])
    end	
    if @relation.errors.present?
    	(@relation.errors.full_messages[0]=="Artist has already been taken")?(@relation.errors.full_messages[0]="Relationship already exists?"):("") 	
    	redirect_to :back,:notice=>@relation.errors.full_messages[0] and return
    end	
    redirect_to admin_relationships_path     
 end


# form do |f|
 # 	f.inputs "Create Relationship" do 
  #		f.input :artist_id,:label=>"Artist",:as => :select,:collection=>Artist.all.each {|a| [a.name,a.id] }
  #		f.input :relation_id,:label=>"Relative",:as => :select,:collection=>Artist.all.each {|a| [a.name,a.id] }
  #		f.input :relationship_type,:label=>"Blood Relation",:collection=>Relationship.new.relation_names.each_with_index {|a,index| [a,index]}
  #  end
  #	f.buttons
  #end
end