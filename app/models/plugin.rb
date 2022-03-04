class Plugin < ApplicationRecord
  belongs_to :url , default: nil

  module Status 
    ACTIVE = 1
    INACTIVE = 0
  end

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }

  def self.import_plugins(plugins, _url, test_id)
   plugins_id = []
    plugins.each do |plugin|
      _plugin = Plugin.where(plugin_name: plugin, url_id: _url, status: 1).first
      if _plugin 
        _version = _plugin.version
        # version 1.1 is for only testing purpose 
        # finding way to find version effectively
        if  _version != '1.1'
          _plugin.status = 0 
          _plugin.save
          new_plugin = Plugin.create(:first_seen => test_id, :last_seen => test_id, plugin_name: plugin, url_id: _url, status: 1, version: '1.1')
          plugins_id << new_plugin.id
        else
          _plugin.update(:last_seen => test_id)
          plugins_id << _plugin.id
        end
      else
        new_plugin = Plugin.create(:first_seen => test_id, :last_seen => test_id, plugin_name: plugin, url_id:_url, status: 1, version: '1.1')
        plugins_id << new_plugin.id
      end
    end
    last_plugins = Url.find(_url).site_data_infos.last.plugins if Url.find(_url).site_data_infos.last
    inactive_removed_plugins(JSON.parse(last_plugins), plugins_id) if last_plugins
    return plugins_id
  end

  def self.inactive_removed_plugins(last_plugins, plugins_id)
    removed_plugins = last_plugins - plugins_id
    removed_plugins.each do |id|
      Plugin.find(id).update(:status => Plugin::Status::INACTIVE)
    end
  end
end
