class Stage < ActiveRecord::Base
  belongs_to :project
  has_many :deployments

  acts_as_list :scope => :project

  validates :title, :presence => true
  validates :deploy_cmd, :presence => true
  validates :next_version_cmd, :presence => true
  validates :current_version_cmd, :presence => true

  def get_current_version
    %x{#{current_version_cmd}}.strip!
  end

  def get_next_version
    %x{#{next_version_cmd}}.strip!
  end

  def get_next_version_short
    get_next_version.slice!(0, 7)
  end

  def get_current_version_short
    get_current_version.slice!(0, 7)
  end

  def log
    @log
  end

  def exitstatus
    @exitstatus
  end
end
