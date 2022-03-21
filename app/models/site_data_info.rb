class SiteDataInfo < ApplicationRecord
  belongs_to :url, required: true
  belongs_to :test, required: true  
  serialize :plugins, Array
  serialize :themes, Array
  serialize :js, Array

  module BasicInfo
    LOGINURL = "login_url"
    PLUGINS = "plugins"
    THEMES = "themes"
    JS = "js"
    CLOUDFLARE = "cloudflare"
    CMS_VERSION = "cms_version"
  end

  def self.import_data(test_id, urls_data, logger)
    site_data_objects = []
    #new_site_data_info_id = SiteDataInfo.last ? SiteDataInfo.last.id : 1 ;
    urls_data.each do |url_id, data|
      maped_data = data[:maped_data]
      cms_version = data[:cms_version]
      cloudflare =  maped_data["cloudflare"].present?
      plugins_arr = maped_data["plugins"] || []
      plugins_arr += maped_data["mu-plugins"] if maped_data["mu-plugins"].present?
      _plugins = Plugin.import_plugins(plugins_arr.uniq, url_id, test_id) if plugins_arr.present?
      _themes = Theme.import_themes(maped_data["themes"].uniq, url_id, test_id) if maped_data["themes"].present?
      _js = JsInfo.import_js(maped_data["js"].uniq, url_id, test_id) if maped_data["js"].present?
      _login_url = maped_data[:login_url]
      _ip = maped_data[:ip]
      data_map = Hash.new
      data_map = {
        :url_id => url_id,
        :test_id => test_id,
        :cloudflare => cloudflare,
        :cms_type => 'wordpress',
        :cms_version => cms_version,
        :js => _js,
        :plugins => _plugins,
        :themes => _themes,
        :login_url => _login_url,
        :ip => _ip
      }
      #Url.find(url_id).update(:site_data_info_id => new_site_data_info_id)
      #new_site_data_info_id += 1
      site_data_objects << create_from_maped_data(data_map, test_id, logger)
    end
    SiteDataInfo.import site_data_objects
    return 
  rescue => e
    logger.info "Test Id: #{test_id} \nError: #{e}"
  end

  def self.create_from_maped_data(data, test_id, logger)
    begin
      site_data_info = self.new(
        url_id: data[:url_id], 
        test_id: data[:test_id],
        cloudflare: data[:cloudflare],
        cms_type: data[:cms_type],
        cms_version: data[:cms_version],
        plugin_ids: data[:plugins],
        themes_ids: data[:themes],
        js_ids: data[:js],
        login_url: data[:login_url],
        ip: data[:ip]
      )
      return site_data_info
    rescue => e
      logger.info "Test Id: #{test_id} \nError: #{e}"
    end
  end

  def basic_info
    basic_data = Hash.new
    basic_data[BasicInfo::PLUGINS] = Plugin.where(:id => source_data.plugin_ids).pluck(:plugin_name)
    basic_data[BasicInfo::THEMES] = Theme.where(:id => source_data.theme_ids).pluck(:theme_name)
    basic_data[BasicInfo::JS] = JsInfo.where(:id => source_data.js_ids).pluck(:js_lib)
    basic_data[BasicInfo::CLOUDFLARE] = self.cloudflare
    basic_data[BasicInfo::LOGINURL] = self.login_url
    basic_data[BasicInfo::CMSVERSION] = self.cms_version
    return basic_data
  end

  def plugins
    return Plugin.where(:id => self.plugin_ids)
  end

  def themes
    return Theme.where(:id => self.theme_ids)
  end

  def js
    return Js.where(:id => self.js_ids)
  end
end
