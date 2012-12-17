require 'pty'

class Runner
  include Celluloid
  INACTIVITY_TIMEOUT = 300 # wait 5 minutes for inactivity

  def initialize(deployment)
    @deployment = deployment
    @timer = after(INACTIVITY_TIMEOUT) { terminate }
  end

  def deploy
    @deployment.project.pull
    begin
      deploy_command = @deployment.stage.deploy_cmd.gsub("{user_name}", @deployment.user)
      PTY.spawn( "cd #{@deployment.project.get_dir_path} && #{deploy_command}" ) do |stdin, stdout, pid|
        begin
          stdin.each do |line|
            @deployment.log += line
            @deployment.save
          end
        rescue Errno::EIO
        end
        Process.wait(pid)
      end
    rescue PTY::ChildExited => e  
    end  
    
    if $?.exitstatus.to_i > 0
      @deployment.status = :error
    else
      @deployment.status = :completed
    end
    
    @deployment.completed_at = Time.now
    @deployment.save

    # delete version cache
    Rails.cache.delete("stage_revision_#{@deployment.stage.id}")
    terminate
  end
end
