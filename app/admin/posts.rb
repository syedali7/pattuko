ActiveAdmin.register Post do
  menu :if => proc{ current_admin_user.role == 'admin' }
  member_action :quick_edit do
    @post = Movie.find(params[:id])
    # This will render app/views/admin/posts/comments.html.erb
  end

  index do
    table_for Post.order("created_at desc").page(params[:page]).per(20) do
        column :id 
        column :title do |post|
            link_to post.title, admin_post_path(:id => post.id)
        end
        column :posting_name do |post|
            posting_name = post.posting_type == "Movie" ? Movie.find(post.posting_id).name : Artist.find(post.posting_id).name
            posting_name
        end
        column :posting_type
        column :posting_id
        column :postable_type
        column :created_at
        column :user_id do |post|
            link_to post.user_id, admin_user_path(:id => post.user_id)
        end
    end
  end
  
  show do
      render 'posts_show'
  end

  form do |f|
    f.inputs 'New post' do 
      f.input :type, :label => 'Post Type', :as => :select, 
          :collection => PostType.all.map{ |u| [u.type, u.id] }
      f.input :title
    end
    f.buttons
  end

end
