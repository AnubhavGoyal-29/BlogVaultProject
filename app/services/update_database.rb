class UpdateDatabase
  class << self
    def update_data(test_no,urls_data)
      urls_data.each do |data| 
        url = data[0]
        hashed_data = data[1]
        cms_version = data[2]

        url_id=Url.where(url:url).first.id

        _plugins = Plugin.import_plugins(hashed_data["plugins"].uniq, url_id)
        plugins_string = _plugins.join(',')

        _themes = Theme.import_themes(hashed_data["themes"].uniq, url_id)
        themes_string = _themes.join(',')

        _js = JsInfo.import_js(hashed_data["js"].uniq, url_id)
        js_string = _js.join(',')

        site_data = SiteData.create(url_id:url_id,test_id:test_no,cms_type:'wordpress',cms_version:cms_version,js:js_string,plugins:plugins_string,themes:themes_string)

        url = Url.where(url:url).first
        url.site_data_id = site_data.id
        url.save
      end 
    end
  end
end
