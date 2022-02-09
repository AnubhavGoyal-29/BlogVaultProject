class Theme < ApplicationRecord
  belongs_to :url, default: nil
end
