class V2::Plugin
  include Mongoid::Timestamps
  include Mongoid::Document

  belongs_to :website
  field :plugin_name, type: String
  field :plugin_slug, type: String
  field :is_active, type: Boolean
  field :first_test, type: Integer
  field :last_test, type: Integer
end
