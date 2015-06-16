require 'fileutils'

class Project < ActiveRecord::Base
  has_many :stages, -> { order(:position) }
  has_many :deployments, :through => :stages
  validates :title, presence: true
  validates :repo, presence: true
  def pull
    # check if directory is a git repo
    begin
      Rugged::Repository.new(get_dir.path)
    rescue
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
    get_repo.diff(commit, head, :context_lines => 3, :interhunk_lines => 1)
  end

  def log(commit, head)
    walker = Rugged::Walker.new(get_repo)
    walker.push(head)
    walker.hide(commit)
    walker.each.to_a
  end
end
