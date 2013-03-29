require 'fileutils'

class Project < ActiveRecord::Base
  attr_accessible :title, :repo
  has_many :stages, :order => "position"
  has_many :deployments, :through => :stages

  def pull
    # check if directory is a git repo
    if !system("cd #{get_dir.path} && git rev-parse")
      system("cd #{get_dir.path} && git clone #{repo} .")
    end

    # update repo
    system("cd #{get_dir.path} && git fetch && git reset --hard origin/master")
  end

  def get_repo
    @repo = Rugged::Repository.new(get_dir.path)
  end

  def get_dir
    # create dir
    if !File.directory? get_dir_path
      FileUtils.mkdir_p get_dir_path
    end

    Dir.new(get_dir_path)
  end

  def get_dir_path
    Deploy::Application.config.project_checkout_path.join(id.to_s)
  end

  def diff(commit, head)
    # todo: optimize this, it is not cool to update repo before every diff
    pull
    %x{cd #{get_dir_path} && git diff #{commit} #{head}}
  end

  def log(commit, head)
    walker = Rugged::Walker.new(get_repo)
    walker.push(head)
    walker.hide(commit)
    walker.each do |c|
      puts c.inspect
    end
    %x{cd #{get_dir_path} && git log --format='%h %cr %s %cn' #{commit}..#{head}}
  end

end
