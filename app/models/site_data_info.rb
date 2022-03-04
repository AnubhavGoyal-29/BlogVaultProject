class SiteDataInfo < ApplicationRecord
  belongs_to :url, required: true
  belongs_to :test, required: true

  module Status
    ACTIVE = "1"
    INACTIVE = "0"
  end
  
  module Filter
   NOT_FOUND = SiteDataInfo.where(:login_url => '0').pluck(:id)
   FOUND = SiteDataInfo.where.not(:login_url => '0').pluck(:id)
  end

  LOGIN_URL = {}  
  Filter.constants.each { |type|
    LOGIN_URL[Filter.class_eval(type.to_s)] = type
  }

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }


  def self.import_data(test_id, urls_data, logger)
    site_data_objects = []
    #new_site_data_info_id = SiteDataInfo.last ? SiteDataInfo.last.id : 1 ;
    urls_data.each do |url_id, data|
      maped_data = data[:maped_data]
      cms_version = data[:version]
      cloudflare =  maped_data['cloudflare'].size > 0
      _plugins = Plugin.import_plugins(maped_data["plugins"].uniq, url_id, test_id)
      _plugins +=  Plugin.import_plugins(maped_data["mu-plugins"].uniq, url_id, test_id) if maped_data["mu-plugins"].count > 0
      _themes = Theme.import_themes(maped_data["themes"].uniq, url_id, test_id)
      _js = JsInfo.import_js(maped_data["js"].uniq, url_id, test_id)
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
          plugins: data[:plugins],
          themes: data[:themes],
          js: data[:js],
          login_url: data[:login_url][0],
          ip: data[:ip][0]
        )
        return site_data_info
      rescue => e
           logger.info "Test Id: #{test_id} \nError: #{e}"
      end
  end
end
