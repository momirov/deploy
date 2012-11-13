class Runner
  include Celluloid
  INACTIVITY_TIMEOUT = 300 # wait 5 minutes for inactivity

  def initialize(deployment)
    @deployment = deployment
    @timer = after(INACTIVITY_TIMEOUT) { terminate }
  end

  def deploy
    @deployment.log = ''
    @deployment.project.pull
    status =
        Open4::popen4("cd #{@deployment.project.get_dir_path} && #{@deployment.stage.deploy_cmd}") do |pid, stdin, stdout, stderr|
          stdout.each do |line|
            @deployment.log += line
            @deployment.save
          end
          stderr.each do |line|
            @deployment.log += line
            @deployment.save
          end

        end

    if status.exitstatus.to_i > 0
      @deployment.status = :error
    else
      @deployment.status = :completed
    end
    @deployment.save
    PrivatePub.publish_to("/deployments/new", deployment: @deployment)
    # delete version cache
    Rails.cache.delete("stage_revision_#{@deployment.stage.id}")
    terminate
  end
end
