class Deployment < ActiveRecord::Base
  belongs_to :stage
  belongs_to :project
  attr_accessible :stage_id, :project_id, :log, :run_time, :status, :user
  after_save :publish

  classy_enum_attr :status

  def publish
    Pusher['deployment'].trigger('update_log', {
        deployment: self
    })

    if self.status == :completed
      Pusher['deployment'].trigger('finished', {
          deployment: self
      })
    end
  end
end
