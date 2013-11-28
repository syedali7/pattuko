desc "populate friends table with user friend associations"
task :get_friends=>:environment do
   @user=User.select("id,uid")
   @ua=@user.collect{|u|[u.uid]}
   @user.each do|user|
      graph=FbGraph::User.fetch(user.uid,:access_token => "571291972902708|204fc1b69e97e1f4b46a8edd2a2de2bd")
      n=graph.friends.size      
      i=0
      @friend=graph.friends.collect{|f|[f.raw_attributes[:id]]}
      while i<n
         
          if @ua.include?(@friend[i])
            @fr=User.find_by_uid(@friend[i])
            Friend.create(:user_id=>user.id,:friend_id=>@fr.id)
            Notification.create(:friend_id=>@fr.id, :notification=>"your friend #{ @fr.username } joined pattuko.com ", :user_id=>user.id, :friend_name=>@fr.username)
          end
          i +=1
      end
  end
end
