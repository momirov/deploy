# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'deploy'
set :repo_url, 'git@github.com:momirov/deploy.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'
set :deploy_to, "/var/www/deploy.saturized.com"
# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle}
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_type, :system # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.0.0-p481'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

desc "Check that we can access everything"
task :check_write_permissions do
  on roles(:all) do |host|
    if test("[ -w #{fetch(:deploy_to)} ]")
      info "#{fetch(:deploy_to)} is writable on #{host}"
    else
      error "#{fetch(:deploy_to)} is not writable on #{host}"
    end
  end
end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do |host|
      run "cd #{current_path} && #{sudo} foreman export upstart /etc/init -a #{application} -u #{user} -l /var/#{application}/log"
    end
  end

  desc "Start the application services"
  task :start do
    on roles(:app) do |host|
      run "#{sudo} service #{application} start"
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles(:app) do |host|
      run "#{sudo} service #{application} stop"
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles(:app) do |host|
      run "#{sudo} service #{application} start || #{sudo} service #{application} restart"
    end
  end
end

namespace :'deploy' do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      #foreman.export

      # on OS X the equivalent pid-finding command is `ps | grep '/puma' | head -n 1 | awk {'print $1'}`
      execute "kill -s SIGUSR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})"

      # foreman.restart # uncomment this (and comment line above) if we need to read changes to the procfile
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
