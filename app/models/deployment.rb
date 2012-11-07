require 'ansible'

class Deployment < ActiveRecord::Base
  include Ansible
  include Celluloid

  belongs_to :stage
  belongs_to :project
  attr_accessible :stage_id, :project_id, :log, :run_time, :status, :user

  classy_enum_attr :status

  def deploy
    self.log = ''
    project.pull
    status =
      Open4::popen4("cd #{project.get_dir_path} && #{stage.deploy_cmd}") do |pid, stdin, stdout, stderr|
        stdout.each do |line|
          self.log += line
          save
        end
        stderr.each do |line|
          self.log += line
          save
        end

      end

    if status.exitstatus.to_i > 0
      self.status = :error
    else
      self.status = :completed
    end
    save
    PrivatePub.publish_to("/deployments/new", deployment: self)
    # delete version cache
    Rails.cache.delete("stage_revision_#{self.stage.id}"
    terminate
  end

  def html_log
    ansi_escaped(self.log)
  end
end
