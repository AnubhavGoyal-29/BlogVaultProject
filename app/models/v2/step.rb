class V2::Step
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :test
  field :status, type: Integer
  field :website_ids, type: Array
  scope :running, -> { where(:status => Status::RUNNING)}
  scope :completed, -> { where(:status => Status::SUCCEED)}
  scope :failed, -> { where(:status => Status::FAILED)}

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

end
