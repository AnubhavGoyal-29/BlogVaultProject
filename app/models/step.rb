class Step < ApplicationRecord
  belongs_to :test
  module Status
    FAILED = 3
    SUCCEED = 2
    RUNNING = 1
    INITIALIZED = 0
  end
  COMPLETED_STATUS = [Status::SUCCEED, Status::FAILED]


  scope :running, -> { where(:status => Status::RUNNING)}
  scope :initialized, -> { where(:status => Status::INITIALIZED)}
  scope :succeed, -> { where(:status => Status::SUCCEED)}  
  scope :failed, -> { where(:status => Status::FAILED)}
  scope :completed, -> { where(:status => COMPLETED_STATUS) }

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }

end
