class Url < ApplicationRecord
  has_many :plugins
  has_many :themes
  belongs_to :site_data_info, required: false
  has_many :site_data_infos


  def self.import_urls(urls)
    urls_id = []
    urls.each do |url|
      _url = Url.where(url: url).first
      if _url
        urls_id << url_id
      else
        _url = Url.create(url: url, site_data_info_id: nil)
        urls_id << _url.id
      end
    end
    return urls_id
  end

end
