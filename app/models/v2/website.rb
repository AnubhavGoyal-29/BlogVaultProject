class V2::Website

  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :first_test, type: String
  field :cms, type: String
end
