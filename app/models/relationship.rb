class Relationship < ActiveRecord::Base
	attr_accessible :artist_id,:relation_id,:relationship_type
	validates_presence_of :artist_id,:relation_id,:relationship_type
	validates_uniqueness_of :artist_id,:scope=>[:relation_id]
	belongs_to :artist
	belongs_to :relative,:class_name=>"Artist",:foreign_key=>:relation_id
    def relation_names

       @list=["GrandFather","GrandMother","Father","Mother",
         "Paternal Uncle","Paternal Aunty","Maternal Uncle",
	 "Maternal Aunty","Brother","Sister","Son","GrandSon",
	 "Daughter","GrandDaugher","Brother-In-Law",
           "Sister-In-Law","Cousin","Nephew","Niece"]
    end
end
