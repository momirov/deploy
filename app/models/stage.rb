require 'helpers'
class Stage < ActiveRecord::Base
  belongs_to :project
  has_many :deployments
  attr_accessible :current_version_cmd, :deploy_cmd, :next_version_cmd, :title

  def get_current_version
    revision = Rails.cache.fetch("stage_revision_#{self.id}", :expires_in => 10.minutes) do
      %x{#{current_version_cmd}}
    end

    if revision.chomp.length == 40
      revision.slice!(0, 7)
    end
  end

  def get_next_version
    %x{#{next_version_cmd}}
  end

  def log
    @log
  end

  def exitstatus
    @exitstatus
  end
end
