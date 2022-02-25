ActiveAdmin.register Plugin do

  actions :index  
  filter :plugin_name
  filter :url_id
  filter :plugin_name
  filter :status , :as => :select, :collection => Plugin::STATUS.invert

  index do 
    id_column
    column :plugin_name
=begin
    column 'Plugin Name' do |plugin|
      link_to plugin.plugin_name, "https://www.wordpress.org/plugins/#{plugin.plugin_name}", :target => 'blank'
    end
=end
    column 'Used IN' do |plugin|
      link_to "#{plugin.url.id} ::  #{plugin.url.url}", admin_url_path(plugin.url)
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
end
