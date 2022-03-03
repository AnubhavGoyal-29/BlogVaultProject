ActiveAdmin.register JsInfo do

  actions :index, :show
  filter :url_id
  filter :status , :as => :select, :collection => JsInfo::STATUS.invert

  index do 
    id_column
    column :js_name
    column 'Version' do |js_info|
      if js_info.version == '0'
        div ("Not found"), :style => 'color : red'
      else 
        js_info.version
      end
    end
    column "Usage" do |js|
      if !params["test_id"]
        url_ids = JsInfo.where(:js_name => js.js_name, :status => JsInfo::STATUS.invert[:ACTIVE]).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      else
        url_ids = JsInfo.where("first_seen <= ?", params["test_id"]).where("last_seen >= ?", params["test_id"]).where(:js_name => js.js_name).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path("q[id_in]" => url_ids)
      end
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

  show do
    attributes_table do
      row :js_name
      row "Usage" do |js|
        url_ids = JsInfo.where(:js_name => js.js_name, :status => JsInfo::STATUS.invert[:ACTIVE]).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      end
    end
  end

end
