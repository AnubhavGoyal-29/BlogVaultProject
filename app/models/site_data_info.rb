class SiteDataInfo < ApplicationRecord
  belongs_to :url, required: true
  belongs_to :test, required: true


  def self.import_data(test_id,urls_data)
    urls_data.each do |key, value|
      maped_data = value[:mapedData]
      cms_version = value[:version]
      cloudflare =  maped_data['cloudflare'].size > 0;
      _plugins = Plugin.import_plugins(maped_data["plugins"].uniq, key)
      _themes = Theme.import_themes(maped_data["themes"].uniq, key)
      _js = JsInfo.import_js(maped_data["js"].uniq, key)
      data_map = Hash.new
      data_map = {
        :url_id => key,
        :test_id => test_id,
        :cloudflare => cloudflare,
        :cms_type => 'wordpress',
        :cms_version => cms_version,
        :js => _js,
        :plugins => _plugins,
        :themes => _themes
      }
      site_data_object_id = create_from_maped_data(data_map)
      url = Url.find(key)
      url.site_data_info_id = site_data_object_id
      url.save
    end
  end

  def self.create_from_maped_data(data)
    site_data_info = self.create(
      url_id: data[:url_id], 
      test_id: data[:test_id]
      cloudflare: data[:cloudflare]
      cms_type: data[:cms_type]
      cms_version: data[:cms_version]
      plugins: data[:plugins]
      themes: data[:themes]
      js: data[:js]
    )
    return site_data_info.id
  end

end
