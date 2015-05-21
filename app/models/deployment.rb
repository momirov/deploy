class Deployment < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  belongs_to :stage
  belongs_to :project

  classy_enum_attr :status
end
