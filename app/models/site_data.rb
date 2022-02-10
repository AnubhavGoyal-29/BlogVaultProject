class SiteData < ApplicationRecord
  has_many :plugin
  has_many :theme

end
