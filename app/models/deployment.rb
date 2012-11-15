class Deployment < ActiveRecord::Base
  belongs_to :stage
  belongs_to :project
  attr_accessible :stage_id, :project_id, :log, :run_time, :status, :user
  after_save :publish

  classy_enum_attr :status

  def publish
    PrivatePub.publish_to("/deployments/new", deployment: self)
  end
end
