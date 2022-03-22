class Plugin < ApplicationRecord
  belongs_to :website, default: nil

  def self.import_plugins(plugins, website_id, test_id)
    plugins_id = []
    plugins.each do |slug|
      _plugin = Plugin.where(:plugin_slug => slug, :website_id => website_id, :status => true).first
      if _plugin 
        _version = _plugin.version
        if  _version != '1.1'      #for testing purpose
          _plugin.is_active = false
          _plugin.save
          plugin_name = PluginSlug.where(:slug => slug).first&.name || slug
          new_plugin = Plugin.create(:first_test => test_id, :last_test => test_id, :plugin_name => plugin_name, 
                                     plugin_slug: slug, website_id: website_id, is_active: true, version: '1.1')
          plugins_id << new_plugin.id
        else
          _plugin.update(:last_test => test_id)
          plugins_id << _plugin.id
        end
      else
        plugin_name = PluginSlug.where(:slug => slug).first&.name || slug
        new_plugin = Plugin.create(:first_test => test_id, :last_test => test_id, plugin_name: plugin_name, 
                                   :plugin_slug => slug, website_id: website_id, is_active: true, version: '1.1')
        plugins_id << new_plugin.id
      end
    end
    last_plugins = Website.find(website_id).site_data_infos.last&.plugin_ids
    inactive_removed_plugins(last_plugins, plugins_id) if last_plugins.present?
  rescue => e
    logger.info "error #{e} from plugin"
  end

  def self.inactive_removed_plugins(last_plugins, plugins_id)
    removed_plugins = last_plugins - plugins_id
    removed_plugins.each do |id|
      Plugin.find(id).update(:is_active => false)
    end
    return plugins_id
  end
end
