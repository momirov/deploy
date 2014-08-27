class Deployment < ActiveRecord::Base
  belongs_to :stage
  belongs_to :project
  attr_accessible :stage_id, :project_id, :log, :run_time, :status, :user

  classy_enum_attr :status
end
