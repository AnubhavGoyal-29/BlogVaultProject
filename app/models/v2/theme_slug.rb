class V2::ThemeSlug
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :slug, type: String
end
