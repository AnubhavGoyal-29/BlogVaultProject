class UpdateDatabase

  def update_data(test_no,data)
    data.each do |i| 
      _url = i[0]
      _data = i[1]

      _url_id=Url.where(url:_url).first.id
      _plugins = Plugin.import_plugins(_data['plugins'],_url_id)
      all_plugins = _plugins.join(',')
      _themes = Theme.import_themes(_data['themes'],_url_id)
      all_themes = _theme.join(',')
      _js = J.import_js(_data['js'],_url_id)
      all_js = _js.join(',')

 

      SiteData.create(js:all_js  ,plugins:all_plugins  ,themes:all_themes )
    end
  end
end
