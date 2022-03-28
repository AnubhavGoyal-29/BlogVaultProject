class V2::Step
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: Integer
  field :websites, type: Array
  field :test_id, type: String
end
