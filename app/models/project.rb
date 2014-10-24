require 'fileutils'
require 'pp'

class Project < ActiveRecord::Base
  has_many :stages, -> { order(:position) }
  has_many :deployments, :through => :stages
  has_one :ssh_key

  validates :title, presence: true
  validates :repo, presence: true

  def ssh_key_credential
    Rugged::Credentials::SshKey.new({
        username: 'deploy',
        publickey: self.ssh_key.public_key,
        privatekey: self.ssh_key.private_key,
        passphrase: self.ssh_key.passphrase,
    })
  end

  def get_repo
    begin
      @repo = Rugged::Repository.new(get_dir.path)
    rescue
      @repo = Rugged::Repository.clone_at(repo, get_dir.path, {credentials: self.ssh_key_credential})
    end
    @repo.fetch('origin', {credentials: self.ssh_key_credential})
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
    get_repo.diff(commit, head, :context_lines => 3, :interhunk_lines => 1)
  end

  def log(commit, head)
    walker = Rugged::Walker.new(get_repo)
    walker.push(head)
    walker.hide(commit)
    walker.each.to_a
  end

end
