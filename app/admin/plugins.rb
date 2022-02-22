ActiveAdmin.register Plugin do

  actions :index  
  filter :plugin_name
  filter :url_id
  filter :status , :as => :select, :collection => Plugin::STATUS.invert

  index do 
    column :id
    column :plugin_name
    column 'Url' do |plugin|
      link_to "#{plugin.url.id} ::  #{plugin.url.url}", admin_url_path(plugin.url)
    end
    column 'Status' do |plugin|
   status = plugin.status
      if status == '0'
        div (Plugin::STATUS[status]),style: "color: red"
      elsif status =='1'
        div (Plugin::STATUS[status]),style: "color: green"
      end
    end
  end
end
