class V2::JsInfo
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :website
  field :js_lib, type: String
  field :is_active, type: Boolean
  field :version, type: String
  field :first_test, type: Integer
  field :last_test, type: Integer
end
