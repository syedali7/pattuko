ActiveAdmin.register Product do
	menu :if => proc{ current_admin_user.role == 'admin' }

end
