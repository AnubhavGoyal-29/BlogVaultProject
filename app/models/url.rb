class Url < ApplicationRecord
  has_and_belongs_to_many :test, required: false
  has_many :plugins
  has_many :themes

end
