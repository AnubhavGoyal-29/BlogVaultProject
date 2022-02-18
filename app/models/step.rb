class Step < ApplicationRecord
  module Status
    FAILED = "3"
    COMPLETED = "2"
    RUNNING = "1"
    INITIALIZED = "0"
  end

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }

end
