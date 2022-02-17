ActiveAdmin.register Plugin do

  actions :index  

  filter :url_id
  filter :status , :as => :select, :collection => Plugin::STATUS.invert

  index do 
    column :id
    column :plugin_name
    column 'Url' do |plugin|
      link_to "#{plugin.url.id} ::  #{plugin.url.url}", admin_url_path(plugin.url)
    end
    column 'Status' do |plugin_status|
      div (Plugin::STATUS[plugin_status.status])
    end
  end
end
