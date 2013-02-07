# Execute "bundle install" after deploy, but only when really needed
require "bundler/capistrano"

set :application, "Deployment"
set :repository,  "ssh://gerrit.saturized.com:29418/deployment"
set :deploy_to, "/srv/http/deployment"
set :user, "root"
set :use_sudo, false
set :scm, :git
default_run_options[:shell] = '/usr/bin/fish'

set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

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
    run "cd #{current_path} && bluepill restart unicorn --no-privilege"
  end
end

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end
