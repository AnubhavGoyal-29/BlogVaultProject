class V2::Website

  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :first_test, type: String
  field :cms, type: String

  def self.import_urls(urls)
    urls_id = []
    urls.each do |url|
      _url = self.where(url: url).first
      if _url
        urls_id << website_id
      else
        _url = self.create(url: url, site_data_info_id: nil)
        urls_id << _url.id
      end
    end
    return urls_id
  end

  def self.url_site_data_info_update(test_id, logger)
    logger.info "Test Id : #{test_id}  Message : Url last_site_data  updated started"
    self.all.each do |url|
      begin
        site_data_info = V2::SiteDataInfo.where(test_id: test_id, website_id: url.id).first
        url.site_data_info_id = site_data_info ? site_data_info.id : url.site_data_info_id
        url.save!
      rescue => e
        logger.info "Test Id : #{test_id} Error: #{e.message} Backtrace: #{e.backtrace}"
      end
    end
  end

  def compare_test(source_test, final_test)
    source_data = V2::SiteDataInfo.where(:test_id => source_test, :website_id => self.id).first
    final_data = V2::SiteDataInfo.where(:test_id => final_test, :website_id => self.id).first

    source_test_plugins = source_data.basic_info[V2::SiteDataInfo::BasicInfo::PLUGINS]
    final_test_plugins = final_data.basic_info[V2::SiteDataInfo::BasicInfo::PLUGINS]
    plugins_common = source_test_plugins & final_test_plugins
    source_test_plugins -= plugins_common
    final_test_plugins -= plugins_common

    source_test_themes = source_data.basic_info[V2::SiteDataInfo::BasicInfo::THEMES]
    final_test_themes = final_data.basic_info[V2::SiteDataInfo::BasicInfo::THEMES]
    themes_common = source_test_themes & final_test_themes
    source_test_themes -= themes_common
    final_test_themes -= themes_common

    source_test_js = source_data.basic_info[V2::SiteDataInfo::BasicInfo::JS]
    final_test_js = final_data.basic_info[V2::SiteDataInfo::BasicInfo::JS]
    js_common = source_test_js & final_test_js
    source_test_js -= js_common
    final_test_js -= js_common

    data_1 = {
      :login_url => source_data.basic_info[V2::SiteDataInfo::BasicInfo::LOGINURL],
      :cloudflare => source_data.basic_info[V2::SiteDataInfo::BasicInfo::CLOUDFLARE],
      :cms_version => source_data.basic_info[V2::SiteDataInfo::BasicInfo::CMSVERSION],
      :plugin => source_test_plugins,
      :theme => source_test_themes,
      :js => source_test_js
    }
    data_2 = {
      :login_url => final_data.basic_info[V2::SiteDataInfo::BasicInfo::LOGINURL],
      :cloudflare => final_data.basic_info[V2::SiteDataInfo::BasicInfo::CLOUDFLARE],
      :cms_version => final_data.basic_info[V2::SiteDataInfo::BasicInfo::CMSVERSION],
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

  def timeline_for_plugins(from, to)
    # doing for plugin
    plugin_ids = V2::Plugin.where(:website => self).pluck(:id, :plugin_name).to_h
    plugin_ids = Hash[plugin_ids.collect{|k,v| [k.to_s, v]}]
    plugin_timeline = {}
    plugin_ids.each do |key, value|
      plugin_timeline[value] = [false]
    end
    puts plugin_timeline
    V2::Test.where({:created_at.gte => from, :updated_at.lte => to}).each do |test|
      test_plugin_ids = V2::SiteDataInfo.where(:test => test, :website => self).first&.plugin_ids
      test_plugin_ids ||= []
      test_plugin_ids&.each do |id|
        plugin_timeline[plugin_ids[id]] << true
      end
      (plugin_ids&.keys - test_plugin_ids)&.each do |id|
        plugin_timeline[plugin_ids[id]] << false
      end
    end

    return plugin_timeline
  end

  def timeline_for_themes(from, to)
    # doing for themes
    theme_ids = V2::Theme.where(:website => self).pluck(:id, :theme_name).to_h
    theme_ids = Hash[theme_ids.collect{|k,v| [k.to_s, v]}]
    theme_timeline = {}
    theme_ids.each do |key, value|
      theme_timeline[value] = []
    end
    V2::Test.where({:created_at.gte => from, :updated_at.lte => to}).each do |test|
      test_theme_ids = V2::SiteDataInfo.where(:test => test, :website => self).first&.theme_ids
      test_theme_ids ||= []
      test_theme_ids&.each do |id|
        theme_timeline[theme_ids[id]] << true if theme_ids[id].present?
      end
      (theme_ids&.keys - test_theme_ids)&.each do |id|
        theme_timeline[theme_ids[id]] << false
      end
    end

    return theme_timeline
  end


  def self.cms
    return ["wordpress", "joomla", "drupal", "shopify", "woocommerce"]
  end

end
