class UpdateDatabase

  def update_data(test_no,data)
    puts "called update database"
    data.each do |i| 
      _url = i[0]
      _data = i[1]
      _url_id=Url.where(url:_url).first.id
      _plugins = Plugin.import_plugins(_data['plugins'].uniq,_url_id)
      all_plugins = _plugins.join(',')
      puts all_plugins
      _themes = Theme.import_themes(_data['themes'].uniq,_url_id)
      all_themes = _themes.join(',')
      puts all_themes
      _js = JsInfo.import_js(_data['js'].uniq,_url_id)
      all_js = _js.join(',')
      puts all_js
 
      
      site_data = SiteData.create(js:all_js  ,plugins:all_plugins  ,themes:all_themes )
      TestDataInfo.create(url_id:_url_id,site_data_id:site_data.id,t_no:test_no)
    end
    puts "database update completed"
    return 
  end
end
