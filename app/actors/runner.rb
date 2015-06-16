require 'pty'

class Runner
  include SuckerPunch::Job
  INACTIVITY_TIMEOUT = 300 # wait 5 minutes for inactivity

  def deploy(deployment, cmd)
    begin
      deploy_command = cmd.gsub("{user_name}", deployment.user)
      Bundler.with_clean_env do
        PTY.spawn( "cd #{deployment.project.get_dir_path} && #{deploy_command}" ) do |stdout, stdin, pid|
          begin
            stdout.each do |line|
              deployment.log += line
              Pusher["deployment_#{deployment.id}"].trigger('update_log', {
                  new_line: line,
                  status: deployment.status
              })
              Rails.cache.write("log_#{deployment.id}", deployment.log)
            end
          rescue Errno::EIO
          end
          Process.wait(pid)
        end
      end
    rescue PTY::ChildExited => e
    end

    if $?.exitstatus.to_i > 0
      deployment.status = :error
    else
      deployment.status = :completed
    end

    deployment.completed_at = Time.now
    deployment.save
    Rails.cache.delete("log_#{deployment.id}")
    Pusher["deployment"].trigger('finished', {
        id: deployment.id,
        status: deployment.status
    })

    # delete version cache
    Rails.cache.delete("stage_revision_#{deployment.stage.id}")
    terminate
  end
end
