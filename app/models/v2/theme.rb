class V2::Theme
  include Mongoid::Timestamps
  include Mongoid::Document

  belongs_to :website
  field :theme_name, type: String
  field :theme_slug, type: String
  field :is_active, type: Boolean
  field :first_test, type: Integer
  field :last_test, type: Integer
end
