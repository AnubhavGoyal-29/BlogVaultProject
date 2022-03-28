class V2::SiteDataInfo
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :test
  belongs_to :website
  field :cms_type
  field :cms_version
  field :js_ids
  field :plugin_ids
  field :theme_ids
  field :cloudflare
  field :login_url
  field :host_name
  field :ip
end
