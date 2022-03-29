class V2::Step
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :test

  scope :running, -> { where(:status => Status::RUNNING)}
  scope :completed, -> { where(:status => Status::COMPLETED)}

  module Status
    INITIALIZED = 0
    RUNNING =1
    COMPLETED = 2
    FAILED = 3
  end

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }

  field :status, type: Integer
  field :website_ids, type: Array
end
