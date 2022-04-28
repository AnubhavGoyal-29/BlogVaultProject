class V2::Step
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :test
  field :status, type: Integer
  field :website_ids, type: Array

  module Status
    INITIALIZED = 0
    RUNNING =1
    SUCCEED = 2
    FAILED = 3
  end

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }

  COMPLETED_STATUS = [Status::SUCCEED, Status::FAILED]

  scope :running, -> {where(:status => Status::RUNNING)}
  scope :succeed, -> {where(:status => Status::SUCCEED)}
  scope :failed, -> {where(:status => Status::FAILED)}
  scope :completed, -> {V2::Step.in(:status => COMPLETED_STATUS)}
end
