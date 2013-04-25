class Stage < ActiveRecord::Base
  belongs_to :project
  has_many :deployments
  attr_accessible :current_version_cmd,
                  :deploy_cmd,
                  :next_version_cmd,
                  :title,
                  :position,
                  :rollback_cmd

  acts_as_list :scope => :project

  validates :title, :presence => true
  validates :deploy_cmd, :presence => true
  validates :next_version_cmd, :presence => true
  validates :current_version_cmd, :presence => true

  def get_current_version
    revision = Rails.cache.fetch("stage_revision_#{self.id}",
                                 :expires_in => 24.hours) do
      %x{#{current_version_cmd}}
    end
    revision.strip
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
