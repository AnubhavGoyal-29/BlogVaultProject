class SiteDataInfo < ApplicationRecord
  belongs_to :url, required: true
  belongs_to :test, required: true

  def self.import_data(data)
    site_data_info = SiteDataInfo.create(
      url_id: url_id, 
      test_id: test_no, 
      cloudflare: cloudflare, 
      cms_type: 'wordpress', 
      cms_version: cms_version,
      js: _js, 
      plugins: _plugins, 
      themes: _themes 
    )
    return site_data_info.id
  end

end
