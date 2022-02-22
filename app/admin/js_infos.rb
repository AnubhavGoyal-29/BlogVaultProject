ActiveAdmin.register JsInfo do

  actions :index

  filter :url_id
  filter :status , :as => :select, :collection => JsInfo::STATUS.invert

  index do
    column :id
    column :js_name
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
