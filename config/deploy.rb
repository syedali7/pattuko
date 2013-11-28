set :application, 'pattuko'
set :repo_url, 'https://pl2.projectlocker.com/famru/svn'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

 set :deploy_to, '/var/apps/#{application}/svn'
 set :scm, :svn
 set :user, "deployer"
 set :deploy_via, :remote_cache
 set :use_sudo, false
 after "deploy", "deploy:cleanup" 

# set :format, :pretty
# set :log_level, :debug
 set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  %W[start stop restart].each do |command|
	task command do
  	      run "/etc/init.d/unicorn #{command}"
	end
  end
  task :setup do
	run "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
       run "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn"
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
  after "deploy:setup", "deploy:restart"
  after "deploy", "deploy:cleanup"
  after :finishing, 'deploy:cleanup'

end
