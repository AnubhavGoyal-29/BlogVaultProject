class UpdateDatabase
  class << self

    def logger
      @logger ||= Logger.new("log/testing.log")
    end

    def update_data(test_id, urls_data)
      logger.info "SERVICE_OBJECT_UPDATE_DATABASE_IS_CALLED"
      urls_data.each do |key, value| 
        maped_data = value[0]
        cms_version = value[1]
        cloudflare =  maped_data['cloudflare'].size > 0 ? 1 : 0 ; 
        url_id=Url.where(url: key).first.id

        _plugins = Plugin.import_plugins(maped_data["plugins"].uniq, url_id)

        _themes = Theme.import_themes(maped_data["themes"].uniq, url_id)

        _js = JsInfo.import_js(maped_data["js"].uniq, url_id)
        

        data_map = Hash.new
        data_map['url_id'] = url_id
        data_map['test_id'] = test_id
        data_map['cloudflare'] = cloudflare
        data_map['cms_type'] = wordpress
        data_map['cms_version'] = cms_version
        data_map['js'] = _js
        data_map['plugins'] = _plugins
        data_map['themes'] = _themes

        site_data_object = SiteDataInfo.import_data(data_map)

        url = Url.where(url: key).first
        url.site_data_info_id = site_data_object.id
        url.save
      end 
    end
  end
end
