# Minimal sample configuration file for Unicorn (not Rack) when used
# with daemonization (unicorn -D) started in your working directory.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
# See also http://unicorn.bogomips.org/examples/unicorn.conf.rb for
# a more verbose configuration using more features.

listen "/home/shippingeasy/deployment/current/tmp/pids/unicorn.sock", :backlog => 1024
worker_processes 2 # this should be >= nr_cpus
pid_path = "tmp/pids/unicorn.pid"
timeout 30
preload_app true
pid pid_path
stderr_path "log/unicorn-err.log"
stdout_path "log/unicorn-out.log"

before_fork do |server, worker|
  # http://codelevy.com/2010/02/09/getting-started-with-unicorn.html
  old_pid = 'tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  sleep 1
end

after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end
end
