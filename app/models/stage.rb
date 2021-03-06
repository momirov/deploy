require 'pp'

class Stage < ActiveRecord::Base
  belongs_to :project
  has_many :deployments

  acts_as_list :scope => :project

  validates :title, :presence => true
  validates :deploy_cmd, :presence => true
  validates :branch, :presence => true
  validates :current_version_cmd, :presence => true

  def get_current_version
    Rails.cache.fetch("stage_revision_#{self.id}",
                                 :expires_in => 24.hours) do
      %x{#{current_version_cmd}}.strip!
    end
  end

  def get_next_version
    repo = self.project.get_repo
    repo.checkout_tree(repo.rev_parse(self.branch), :strategy => :force)
    repo.rev_parse_oid(self.branch)
  end

  def get_next_version_short
    get_next_version.slice(0, 7)
  end

  def get_current_version_short
    get_current_version.slice(0, 7)
  end

  def log
    @log
  end

  def exitstatus
    @exitstatus
  end

  def get_deploy_command
    ["cd #{project.get_dir_path}", install_dependency, deploy_cmd].flatten.compact.join(' && ')
  end

  def install_dependency
    commands = []
    if File.exist?(self.project.get_dir_path.join('Gemfile'))
      commands << 'bundle install --binstubs'
    end
    if npm_support && File.exist?(self.project.get_dir_path.join('package.json'))
      commands << 'npm install --silent'
    end
  end
end
