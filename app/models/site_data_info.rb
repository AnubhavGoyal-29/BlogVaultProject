class SiteDataInfo < ApplicationRecord
  belongs_to :url, required: true
  belongs_to :test, required: true


  def self.import_data(test_id, urls_data, logger)
    site_data_objects = []
    #new_site_data_info_id = SiteDataInfo.last ? SiteDataInfo.last.id : 1 ;
    urls_data.each do |url_id, data|
      maped_data = data[:mapedData]
      cms_version = data[:version]
      cloudflare =  maped_data['cloudflare'].size > 0
      _plugins = Plugin.import_plugins(maped_data["plugins"].uniq, url_id)
      _themes = Theme.import_themes(maped_data["themes"].uniq, url_id)
      _js = JsInfo.import_js(maped_data["js"].uniq, url_id)
      data_map = Hash.new
      data_map = {
        :url_id => url_id,
        :test_id => test_id,
        :cloudflare => cloudflare,
        :cms_type => 'wordpress',
        :cms_version => cms_version,
        :js => _js,
        :plugins => _plugins,
        :themes => _themes
      }
      #Url.find(url_id).update(:site_data_info_id => new_site_data_info_id)
      #new_site_data_info_id += 1
      site_data_objects << create_from_maped_data(data_map, logger)
    end
    SiteDataInfo.import site_data_objects
    return 
  end

  def self.create_from_maped_data(data, logger)
      begin
        site_data_info = self.new(
          url_id: data[:url_id], 
          test_id: data[:test_id],
          cloudflare: data[:cloudflare],
          cms_type: data[:cms_type],
          cms_version: data[:cms_version],
          plugins: data[:plugins],
          themes: data[:themes],
          js: data[:js]
        )
        return site_data_info
      rescue => e
        logger.info e
      end
  end
end
