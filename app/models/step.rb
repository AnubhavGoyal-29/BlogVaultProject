class Step < ApplicationRecord
  belongs_to :test
  

  scope :running, -> { where(:status => Status::RUNNING)}
  scope :initialized, -> { where(:status => Status::INITIALIZED)}
  scope :succeed, -> { where(:status => Status::SUCCEED)}  
  scope :failed, -> { where(:status => Status::FAILED)}
  scope :completed, -> { where.not(:status => Status::INITIALIZED).where.not(:status => Status::RUNNING) }

  module Status
    FAILED = 3
    SUCCEED = 2
    RUNNING = 1
    INITIALIZED = 0
  end

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }

end
