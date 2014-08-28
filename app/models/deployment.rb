class Deployment < ActiveRecord::Base
  belongs_to :stage
  belongs_to :project

  classy_enum_attr :status
end
