class V2::Test
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, type: Integer
  field :number_of_websites, type: Integer
  field :started_at, type: Time
  field :number, type: Integer

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

  def self.history_of_tests
    key -> test numbers 
    hashes = [{:name => 'total sites', :data => {}},{:name => 'wordpress sites', :data => }]
  end

end
