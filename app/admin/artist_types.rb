ActiveAdmin.register ArtistType	 do
  menu :if => proc{ current_admin_user.role == 'admin' }
  index do 
  	column :name
    column :priority
    column :points
  	default_actions
  end
  form do |f|
  	f.inputs 'create artist' do 
  		f.input :name
      f.input :priority
      f.input :points
  	end
  	f.buttons
  end  
end
