class Test < ApplicationRecord
  has_many :steps
  has_many :site_data_infos
  module Status
    COMPLETE = '1'
    RUNNING = '0'
  end

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }
end
