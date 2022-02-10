class TestDataInfo < ApplicationRecord
  belongs_to :url,        required: false
  belongs_to :site_data , required: false
end
