class V2::Step
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :test
end
