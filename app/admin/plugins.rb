ActiveAdmin.register Plugin do

  actions :index, :show  
  filter :plugin_name
  filter :url_id
  filter :plugin_name
  filter :status , :as => :select, :collection => Plugin::STATUS.invert

  index do 
    id_column
    column 'Name' do|plugin|
      name = ( PluginSlug.where("slug LIKE?", "%#{ plugin.plugin_name }%").first && PluginSlug.where("slug LIKE?", "%#{ plugin.plugin_name }%").first.name ) 
      name ||= plugin.plugin_name
      div (name)
    end
=begin
    column 'Plugin Name' do |plugin|
      link_to plugin.plugin_name, "https://www.wordpress.org/plugins/#{plugin.plugin_name}", :target => 'blank'
    end
=end
    column "Usage" do |plugin|
      url_ids = Plugin.where(:plugin_name => plugin.plugin_name, :status => Plugin::STATUS.invert[:ACTIVE]).pluck(:url_id)
      link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
    end
    column 'Status' do |plugin|
      status = plugin.status
      options = Plugin::STATUS.invert
      if status == options[:INACTIVE]
        div (Plugin::STATUS[status]),style: "color: red"
      elsif status == options[:ACTIVE]
        div (Plugin::STATUS[status]),style: "color: green"
      end
    end
  end

  show do
    attributes_table do
      row :plugin_name
      row "Usage" do |plugin|
        url_ids = Plugin.where(:plugin_name => plugin.plugin_name, :status => Plugin::STATUS.invert[:ACTIVE]).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      end
    end
  end
end

