ActiveAdmin.register JsInfo do

  actions :index, :show
  filter :js_lib
  filter :url_id
  filter :status 
  filter :first_seen
  filter :last_seen
  filter :created_at
  filter :updated_at

  index do 
    id_column
    column :js_lib
    column 'Version' do |js_info|
      if js_info.version == nil
        div ("Not found"), :style => 'color : red'
      else 
        js_info.version
      end
    end
    column "Usage" do |js|
      args = Hash.new
      args[:js_lib] = js.js_lib
      if params["test_id"]
        args[:first_seen] = -Float::INFINITY..params['test_id'].to_i
        args[:last_seen] = params['test_id'].to_i..Float::INFINITY
      end
      url_ids = JsInfo.where(args).pluck(:url_id)
      link_to "#{url_ids.count} :: urls", admin_urls_path("q[id_in]" => url_ids)
    end
    column :first_seen
    column :last_seen
    if params[:q] and params[:q][:url_id_equals]
      column 'Status' do |js|
        status = js.status ? "ACTIVE" : "INACTIVE"
        color = js.status ? "green" : "red"
        div status, style: "color: #{color}"
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :js_lib
      row 'Version' do |js_info|
        if js_info.version == nil
          div ("Not found"), :style => 'color : red'
        else
          js_info.version
        end
      end
      row "Usage" do |js|
        url_ids = JsInfo.where(:js_lib => js.js_lib, :status => true).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      end
      row :first_seen
      row :last_seen
      if params[:q]
        row 'Status' do |js|
          status = js.status ? "ACTIVE" : "INACTIVE"
          color = js.status ? "green" : "red"
          div status, style: "color: #{color}"
        end
      end
    end
  end
end
