class V2::SiteDataInfo
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :test
  belongs_to :website
  field :cms_type
  field :cms_version
  field :js_ids
  field :plugin_ids
  field :theme_ids
  field :cloudflare
  field :login_url
  field :host_name
  field :ip

  module BasicInfo
    LOGINURL = "login_url"
    PLUGINS = "plugins"
    THEMES = "themes"
    JS = "js"
    CLOUDFLARE = "cloudflare"
    CMSVERSION = "cms_version"
  end

  def self.import_data(test_id, urls_data, logger)
    site_data_objects = []
    #new_site_data_info_id = SiteDataInfo.last ? SiteDataInfo.last.id : 1 ;
    urls_data.each do |website_id, data|
      maped_data = data[:maped_data]
      cms_version = data[:cms_version]
      cloudflare =  maped_data["cloudflare"].present?
      plugins_arr = maped_data["plugins"] || []
      plugins_arr += maped_data["mu-plugins"] if maped_data["mu-plugins"].present?
      _plugins = V2::Plugin.import_plugins(plugins_arr.uniq, website_id, test_id) if plugins_arr.present?
      _themes = V2::Theme.import_themes(maped_data["themes"].uniq, website_id, test_id) if maped_data["themes"].present?
      _js = V2::JsInfo.import_js(maped_data["js"].uniq, website_id, test_id, logger) if maped_data["js"].present?
      _login_url = maped_data[:login_url]
      _ip = maped_data[:ip]
      data_map = Hash.new
      data_map = {
        :website_id => website_id,
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
      #Url.find(website_id).update(:site_data_info_id => new_site_data_info_id)
      #new_site_data_info_id += 1
      create_from_maped_data(data_map, test_id, logger)
    end
    return 
  rescue => e
    logger.info "Test Id: #{test_id} File : site_data_info.rb Error: #{e}"
  end

  def self.create_from_maped_data(data, test_id, logger)
    begin
      site_data_info = self.create(
        website_id: data[:website_id], 
        test_id: data[:test_id],
        cloudflare: data[:cloudflare],
        cms_type: data[:cms_type],
        cms_version: data[:cms_version],
        plugin_ids: data[:plugins],
        theme_ids: data[:themes],
        js_ids: data[:js],
        login_url: data[:login_url],
        ip: data[:ip]
      )
      return site_data_info
    rescue => e
      logger.info "Test Id: #{test_id} File : site_data_info.rb Error: #{e}"
    end
  end

  def basic_info
    basic_data = Hash.new
    basic_data[BasicInfo::PLUGINS] = self.plugins.pluck(:plugin_name)
    basic_data[BasicInfo::THEMES] = self.themes.pluck(:theme_name)
    basic_data[BasicInfo::JS] = self.js.pluck(:js_lib)
    basic_data[BasicInfo::CLOUDFLARE] = self.cloudflare
    basic_data[BasicInfo::LOGINURL] = self.login_url
    basic_data[BasicInfo::CMSVERSION] = self.cms_version
    return basic_data
  end

  def plugins
    return V2::Plugin.in(:id => self.plugin_ids)
  end

  def themes
    return V2::Theme.in(:id => self.theme_ids)
  end

  def js
    return V2::JsInfo.in(:id => self.js_ids)
  end

end
