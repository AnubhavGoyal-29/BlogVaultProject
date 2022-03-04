class Test < ApplicationRecord
  has_many :steps, dependent: :destroy
  has_many :site_data_infos
  module Status
    FAILED = 3
    COMPLETED = 2
    INITIALIZED = 0
    RUNNING =1
  end

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }
end
