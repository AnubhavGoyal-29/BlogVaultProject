class Url < ApplicationRecord
  has_many :site_data_infos, dependent: :destroy
  has_many :plugins, dependent: :destroy
  has_many :themes, dependent: :destroy
  has_many :js_inos, dependent: :destroy

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

  def compare_test(source_test, final_test)
    source_data = SiteDataInfo.where(:test_id => source_test, :url_id => self.id).first
    final_data = SiteDataInfo.where(:test_id => final_test, :url_id => self.id).first

    source_test_plugins = Plugin.where(:id => source_data.plugin_ids).pluck(:plugin_name)
    final_test_plugins = Plugin.where(:id => final_data.plugin_ids).pluck(:plugin_name)
    plugins_common = source_test_plugins & final_test_plugins
    source_test_plugins = source_test_plugins - plugins_common
    final_test_plugins = final_test_plugins - plugins_common

    source_test_themes = Theme.where(:id => source_data.theme_ids).pluck(:theme_name)
    final_test_themes = Theme.where(:id => final_data.theme_ids).pluck(:theme_name)
    themes_common = source_test_themes & final_test_themes
    source_test_themes = source_test_themes - themes_common
    final_test_themes = final_test_themes - themes_common

    source_test_js = Js.where(:id => source_data.js_ids).pluck(:js_name)
    final_test_js = Js.where(:id => final_data.js_ids).pluck(:js_name)
    js_common = source_test_js & final_test_js
    source_test_js = source_test_js - js_common
    final_test_js = final_test_js - js_common

    data_1 = {
      :login_url => source_data.login_url, 
      :cloudflare => source_data.cloudflare, 
      :cms_version => source_data.cms_version, 
      :plugin => source_test_plugins, 
      :theme => source_test_themes, 
      :js => source_test_js
    } 
    data_2 = {
      :login_url => final_data.login_url, 
      :cloudflare => final_data.cloudflare, 
      :cms_version => final_data.cms_version, 
      :plugin => final_test_plugins, 
      :theme => final_test_themes, 
      :js => final_test_js
    }
    data_common = {
      :plugin => plugins_common, 
      :theme => themes_common, 
      :js => js_common
    }
    data = {:data_1 => data_1, :data_2 => data_2, :data_common => data_common, :is_data_changed => data_1 == data_2}
    return data
  end
end
