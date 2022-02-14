class SiteDataInfo < ApplicationRecord
  belongs_to :url, required: true
  belongs_to :test, required: true

end
