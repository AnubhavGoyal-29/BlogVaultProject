ActiveAdmin.register JsInfo do

  actions :index

  filter :url_id
  filter :status , :as => :select, :collection => JsInfo::STATUS.invert

  index do
    column :id
    column :js_name
    column 'Version' do |js_info|
      if js_info.version == '0'
        div ("Not found"), :style => 'color : red'
      else 
        js_info.version
      end
    end
    column 'Url' do |js|
      link_to "#{js.url.id} ::  #{js.url.url}", admin_url_path(js.url)
    end
    column 'Status' do |js|
      status = js.status
      options = JsInfo::STATUS.invert
      if status == options[:INACTIVE]
        div ('INACTIVE'),style: "color: red"
      elsif status == options[:ACTIVE]
        div ('ACTIVE'),style: "color: green"
      end
    end
  end
end
