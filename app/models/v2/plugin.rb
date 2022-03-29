class V2::Plugin
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :website
  field :plugin_name, type: String
  field :plugin_slug, type: String
  field :is_active, type: Boolean
  field :first_test, type: String
  field :last_test, type: String

  def self.import_plugins(plugins, website_id, test_id)
    plugins_id = []
    plugins.each do |slug|
      _plugin = V2::Plugin.where(:plugin_slug => slug, :website => website_id, :is_active => true).first
      if _plugin
        _version = '1.1'
        if  _version != '1.1'      #for testing purpose
          _plugin.is_active = false
          _plugin.save
          plugin_name = V2::PluginSlug.where(:slug => slug).first&.name || slug
          new_plugin = V2::Plugin.create(:first_test => test_id, :last_test => test_id, :plugin_name => plugin_name,
                                         plugin_slug: slug, website: website_id, is_active: true)
          plugins_id << new_plugin.id.to_s
        else
          _plugin.update(:last_test => test_id)
          plugins_id << _plugin.id.to_s
        end
      else
        plugin_name = V2::PluginSlug.where(:slug => slug).first&.name || slug
        new_plugin = V2::Plugin.create(:first_test => test_id, :last_test => test_id, plugin_name: plugin_name,
                                       :plugin_slug => slug, websit: website_id, is_active: true)
        plugins_id << new_plugin.id.to_s
      end
    end
    last_plugins = V2::SiteDataInfo.where(:website => website_id).last&.plugin_ids
    inactive_removed_plugins(last_plugins, plugins_id) if last_plugins.present?
    return plugins_id
  rescue => e
    logger.info "error #{e} from plugin"
  end

  def self.inactive_removed_plugins(last_plugins, plugins_id)
    removed_plugins = last_plugins - plugins_id
    removed_plugins.each do |id|
      V2::Plugin.find(id).update(:is_active => false)
    end
  end
end
