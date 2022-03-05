class Url < ApplicationRecord
  has_many :site_data_infos, dependent: :destroy

  module Cms
    WORDPRESS = "wordpress"
  end
  def self.import_urls(urls)
    urls_id = []
    urls.each do |url|
      _url = self.where(url: url).first
      if _url
        urls_id << url_id
      else
        _url = self.create(url: url, site_data_info_id: nil)
        urls_id << _url.id
      end
    end
    return urls_id
  end

  def self.url_site_data_info_update(test_id, logger)
    logger.info "Test Id : #{test_id} Message : Url last_site_data  updated started"
    self.all.each do |url|
      begin
        site_data_info = SiteDataInfo.where(test_id: test_id, url_id: url.id).first
        url.site_data_info_id = site_data_info ? site_data_info.id : url.site_data_info_id
        url.save!
      rescue => e
        logger.info e
      end
    end
  end

  def compare_two_test(test1, test2)
    test_id_1 = test1
    test_id_2 = test2
    url_id = self.id
    data_1 = SiteDataInfo.where(:test_id => test_id_1, :url_id => url_id).first
    data_2 = SiteDataInfo.where(:test_id => test_id_2, :url_id => url_id).first

    plugin_1 = JSON.parse( data_1.plugins )
    plugin_2 = JSON.parse( data_2.plugins )
    plugins_common = plugin_1 & plugin_2

    for i in 0..( plugin_1.size - 1 )
      plugin_1[i] = Plugin.find(plugin_1[i]).plugin_name if Plugin.find(plugin_1[i]).plugin_name
    end
    for i in 0..( plugin_2.size - 1 )
      plugin_2[i] = Plugin.find(plugin_2[i]).plugin_name if Plugin.find(plugin_2[i]).plugin_name
    end
    for i in 0..( plugins_common.size - 1 )
      plugins_common[i] = Plugin.find(plugins_common[i]).plugin_name
    end
    plugin_1 = plugin_1 - plugins_common
    plugin_2 = plugin_2 - plugins_common

    theme_1 = JSON.parse( data_1.themes )
    theme_2 = JSON.parse( data_2.themes )
    themes_common = theme_1 & theme_2

    for i in 0..( theme_1.size - 1 )
      theme_1[i] = Theme.find(theme_1[i]).theme_name if Theme.find(theme_1[i]).theme_name
    end
    for i in 0..( theme_2.size - 1 )
      theme_2[i] = Theme.find(theme_2[i]).theme_name if Theme.find(theme_2[i]).theme_name
    end
    for i in 0..( themes_common.size - 1 )
      themes_common[i] = Theme.find(themes_common[i]).theme_name
    end

    theme_1 = theme_1 - themes_common
    theme_2 = theme_2 - themes_common

    js_1 = JSON.parse( data_1.js )
    js_2 = JSON.parse( data_2.js )
    js_common = js_1 & js_2

    for i in 0..( js_1.size - 1 )
      js_1[i] = JsInfo.find(js_1[i]).js_name if JsInfo.find(js_1[i]).js_name
    end
    for i in 0..( js_2.size - 1 )
      js_2[i] = JsInfo.find(js_2[i]).js_name if JsInfo.find(js_2[i]).js_name
    end
    for i in 0..( js_common.size - 1 )
      js_common[i] = JsInfo.find(js_common[i]).js_name
    end

    js_1 = js_1 - js_common
    js_2 = js_2 - js_common

    data_1 = {
      :login_url => data_1.login_url, 
      :cloudflare => data_1.cloudflare, 
      :cms_version => data_1.cms_version, 
      :plugin => plugin_1, 
      :theme => theme_1, 
      :js => js_1
    } 
    data_2 = {
      :login_url => data_2.login_url, 
      :cloudflare => data_2.cloudflare, 
      :cms_version => data_2.cms_version, 
      :plugin => plugin_2, 
      :theme => theme_2, 
      :js => js_2
    }
    data_common = {
      :plugin => plugins_common, 
      :theme => themes_common, 
      :js => js_common
    }
    data = {:data_1 => data_1, :data_2 => data_2, :data_common => data_common}
    return data
  end
end
