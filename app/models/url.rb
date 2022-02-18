class Url < ApplicationRecord
  has_many :site_data_infos

  scope :site_data_info, -> { where.not(site_data_info_id: nil) }


  def self.import_urls(urls)
    urls_id = []
    urls.each do |url|
      _url = self.where(url: url).first
      if _url
        urls_id << url_id
      else
        _url = self.create(url: url, site_data_info_id: nil)
        urls_id << _url.id
      end
    end
    return urls_id
  end

  def self.url_site_data_info_update(test_id, logger)
    logger.info "url site info called"
    self.all.each do |url|
      begin
        url.site_data_info_id = SiteDataInfo.where(test_id: test_id, url_id: url.id).first.id
        url.save!
      rescue => e
        logger.info e
      end
    end
  end

end
