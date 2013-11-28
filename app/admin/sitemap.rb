ActiveAdmin.register Sitemap do 
	menu :if => proc{ current_admin_user.role == 'seo' || current_admin_user.role == 'admin' }

end
