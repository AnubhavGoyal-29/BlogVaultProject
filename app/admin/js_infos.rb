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
    column 'Status' do |js_status|
      div (JsInfo::STATUS[js_status.status])
    end
  end

end
