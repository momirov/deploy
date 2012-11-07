set :application, "Deployment"
set :repository,  "ssh://gerrit.saturized.com:29418/deployment"
set :deploy_to, "/home/shippingeasy/deployment/"
set :user, "shippingeasy"
set :use_sudo, false
set :scm, :git
default_run_options[:shell] = '/bin/bash'
set :default_environment, {
  "PATH" => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH",
}

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "deploy"                          # Your HTTP server, Apache/etc
role :app, "deploy"                          # This may be the same as your `Web` server
role :db,  "deploy", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

desc "install the necessary prerequisites"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end
after "deploy:update_code", :bundle_install
