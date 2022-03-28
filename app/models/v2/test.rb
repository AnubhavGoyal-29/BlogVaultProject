class V2::Test
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, type: Integer
  field :number_of_websites, type: Integer
  field :started_at, type: Date
end
