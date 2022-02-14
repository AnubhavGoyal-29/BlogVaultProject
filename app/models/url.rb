class Url < ApplicationRecord
  has_many :plugins
  has_many :themes
  belongs_to :site_data,required: false

  def self.import_urls(data)
    data.each do |key, value|
      _url = Url.where(url: key).first
      if !_url
        _url = Url.create(url: key, site_data_id: nil)
      end
      # later need to add some code
      # _url will be used here
    end
  end

end
