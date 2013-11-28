class Sample < ActionMailer::Base
  default from: "cinenukkadapp@gmail.com"

  def welcome(recipient , username, post)
    @recipient = recipient
    @username = username
    @post = post
    mail :to => recipient, :subject => "Pattuko | Welcome #{username}"
  end

  def thankyou(recipient)
    @recipient = recipient
    mail(to: recipient,
        subject: "Cinenukkad.com - Thank you #{recipient}",
    	body: "Thank you for using our app.."
    )
  end

  def movie_create(movie_name , username)
    @recipient = ["muralikrishna1991@gmail.com" , "bramu.ss@gmail.com", "syedali0111@gmail.com"]
    mail :to => @recipient, :subject => "Movie created",
          body: "#{username} created the new movie called #{movie_name}"
  end

  def artist_create(artist_name , username)
    @recipient = ["muralikrishna1991@gmail.com" , "bramu.ss@gmail.com", "syedali0111@gmail.com"]
    mail :to => @recipient, :subject => "Artist created",
          body: "#{username} created the new Artist called #{artist_name}"
  end

  def event_create(event_name , username)
    @recipient = ["muralikrishna1991@gmail.com" , "bramu.ss@gmail.com", "syedali0111@gmail.com"]
    mail :to => @recipient, :subject => "Artist created",
          body: "#{username} created the new Event called #{event_name}"
  end
  
  def block(post,current_user)
    @recipient = ["muralikrishna1991@gmail.com" , "bramu.ss@gmail.com", "syedali0111@gmail.com"]
    @user=current_user
    mail :to=>@recipient, :subject=>"Requst to Block Abusive post",
         :body=>"User: #{@user.email},Id: #{@user.id} requested to block post_id#{ post.id}"    
  end
  
  def post_created(post,user)
    @recipient = ["muralikrishna1991@gmail.com" , "bramu.ss@gmail.com", "syedali0111@gmail.com","praveenyoungind@gmail.com"]
    mail :to=>@recipient,:subject=>'user post created',:body=>"USER with id #{user} created post id #{post}"
  end

  def no_image(type)
     @recipient = ["muralikrishna1991@gmail.com" , "bramu.ss@gmail.com", "syedali0111@gmail.com","praveenyoungind@gmail.com"]
     @type=type
     mail :to=>@recipient,:subject=>'Movies with no Movie Images'   
  end
   
  def user_notification(msg,email,post)
     mail :to=>email,:subject=>msg,:body=>"hi \n \n greeting from pattuko \n \n #{msg} \n www.pattuko.com" + "#{post.es_show_path}"
  end
  
  def movies_with_no_art(movies)
     @recipient = ["muralikrishna1991@gmail.com" , "bramu.ss@gmail.com", "syedali0111@gmail.com","praveenyoungind@gmail.com"]
     @movies=movies
     mail :to=>@recipient,:subject=>'movies with no artists'
  end

  def daily_report(movies,artists,posts)
    @recipient = "muralikrishna1991@gmail.com"
    mail :to => @recipient, :subject => "daily report",
          body: "#{movies} #{artists} #{posts} "
  end

  def last_log_in_mailing(username, email)
    @recipient = email
    mail :to => @recipient, :subject => "Pattuko.com",
          body: "You are missing some posts"
  end

  def album_scrap_success(post,username)
    @recipient = ["muralikrishna1991@gmail.com" , "bramu.ss@gmail.com", "syedali0111@gmail.com","praveenyoungind@gmail.com"]
    mail :to => @recipient,:subject=>'Album succesfully Scrapped',
    :body=>"#{username} scrapped the album succesfully.. Post id is #{post.id}"
  end

  def album_scrap_failure(username,home_url)
    @recipient = ["muralikrishna1991@gmail.com" , "bramu.ss@gmail.com", "syedali0111@gmail.com","praveenyoungind@gmail.com"]
    mail :to => @recipient,:subject=>'Album Scrapping failed',
    :body=>"Sorry! #{username} has tried to scrap this URL [#{home_url}] for album creation. But something went wrong"
  end

  def news_scraping_failure(error1)
    @recipient = ["sivamaninaidu9@gmail.com"]
    mail :to => @recipient,:subject=>'news Scrapping failed',
    :body=>"Sorry! image_url has tried to scrap this URL [#{error1}]. But something went wrong"
    
  end
  def news_scraping_urls(new_urls)
    @recipient = ["sivamaninaidu9@gmail.com"]
    mail :to => @recipient,:subject => 'news scraping urls',
    :body => "[#{new_urls}]",:content_type=>"text/html"
  end  

end
