ActiveAdmin.register JsInfo do

  actions :index, :show
  filter :url_id
  filter :status 
  filter :first_seen
  filter :last_seen
  filter :created_at
  filter :updated_at

  index do 
    id_column
    column :js_name
    column 'Version' do |js_info|
      if js_info.version == nil
        div ("Not found"), :style => 'color : red'
      else 
        js_info.version
      end
    end
    column "Usage" do |js|
      if !params["test_id"]
        url_ids = JsInfo.where(:js_name => js.js_name, :status => true).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      else
        url_ids = JsInfo.where("first_seen <= ?", params["test_id"]).
          where("last_seen >= ?",params["test_id"]).
          where(:js_name => js.js_name).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path("q[id_in]" => url_ids)
      end
    end
    column :first_seen
    column :last_seen
    if params[:q] and params[:q][:url_id_equals]
      column 'Status' do |js|
        status = js.status
        if status == false
          div ("INACTIVE"),style: "color: red"
        else
          div ("ACTIVE"),style: "color: green"
        end
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :js_name
      row 'Version' do |js_info|
        if js_info.version == nil
          div ("Not found"), :style => 'color : red'
        else
          js_info.version
        end
      end
      row "Usage" do |js|
        if !params["test_id"]
          url_ids = JsInfo.where(:js_name => js.js_name, :status => true).pluck(:url_id)
          link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
        else
          url_ids = JsInfo.where("first_seen <= ?", params["test_id"]).
            where("last_seen >= ?", params["test_id"]).
            where(:js_name => js.js_name).pluck(:url_id)
          link_to "#{url_ids.count} :: urls", admin_urls_path("q[id_in]" => url_ids)
        end
      end
      row :first_seen
      row :last_seen
      if params[:q]
        row 'Status' do |js|
          status = js.status
          if status == false
            div ("INACTIVE"),style: "color: red"
          else
            div ("ACTIVE"),style: "color: green"
          end
        end
      end
    end
  end
end
