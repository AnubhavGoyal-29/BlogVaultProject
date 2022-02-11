class SiteData < ApplicationRecord
  has_many :plugin
  has_many :theme
  belongs_to :url, required: true
  belongs_to :test, required: true

end
