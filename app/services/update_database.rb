class UpdateDatabase
  class << self

    def logger
      @logger ||= Logger.new("log/testing.log")
    end

    def update_data(test_no, urls_data)
      logger.info "SERVICE_OBJECT_UPDATE_DATABASE_IS_CALLED"
      urls_data.each do |key, value| 
        maped_data = value[0]
        cms_version = value[1]
        cloudflare =  maped_data['cloudflare'].size > 0 ? 1 : 0 ; 
        url_id=Url.where(url: key).first.id

        _plugins = Plugin.import_plugins(maped_data["plugins"].uniq, url_id)
        plugins_string = _plugins.join(',')

        _themes = Theme.import_themes(maped_data["themes"].uniq, url_id)
        themes_string = _themes.join(',')

        _js = JsInfo.import_js(maped_data["js"].uniq, url_id)
        js_string = _js.join(',')

        site_data = SiteData.create(
          url_id: url_id, 
          test_id: test_no, 
          cloudflare: cloudflare, 
          cms_type: 'wordpress', 
          cms_version: cms_version,
          js: js_string, 
          plugins: plugins_string, 
          themes: themes_string 
        )
        url = Url.where(url: key).first
        url.site_data_id = site_data.id
        url.save
      end 
    end
  end
end
