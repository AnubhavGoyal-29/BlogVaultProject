class SiteData < ApplicationRecord
  belongs_to :url, required: true
  belongs_to :test, required: true
  has_many :url, dependent: :nullify

end
