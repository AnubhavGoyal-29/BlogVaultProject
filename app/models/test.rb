class Test < ApplicationRecord
  has_and_belongs_to_many :url
  belongs_to :site_data , required: false
end
