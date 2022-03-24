ActiveAdmin.register JsInfo do

  actions :index, :show
  filter :js_lib
  filter :website_id
  filter :is_active, as: :select, collection: [["ACTIVE", true], ["INACTIVE", false]]
  filter :first_test
  filter :last_test
  filter :created_at
  filter :updated_at

  scope '', :default => true do |js_infos|
    js_infos.group(:version)
  end

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
      args[:is_active] = true
      if params["test_id"]
        args[:first_test] = -Float::INFINITY..params['test_id'].to_i
        args[:last_test] = params['test_id'].to_i..Float::INFINITY
        args.delete(:is_active)
      end
      website_ids = JsInfo.where(args).pluck(:website_id)
      link_to "#{website_ids.count} :: urls", admin_websites_path("q[id_in]" => website_ids)
    end
    column 'First Test' do |js|
      "Test #{js.first_test}"
    end
    column 'Last Test' do |js|
      "Test #{js.last_test}"
    end
    if params[:q] and params[:q][:website_id_equals]
      column 'Status' do |js|
        status = js.is_active ? "ACTIVE" : "INACTIVE"
        color = js.is_active ? "green" : "red"
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
        website_ids = JsInfo.where(:js_lib => js.js_lib, :is_active => true).pluck(:website_id)
        link_to "#{website_ids.count} :: urls", admin_websites_path('q[id_in]' => website_ids)
      end
      row :first_test
      row :last_test
      if params[:q]
        row 'Status' do |js|
          status = js.is_active ? "ACTIVE" : "INACTIVE"
          color = js.is_active ? "green" : "red"
          div status, style: "color: #{color}"
        end
      end
    end
  end
end
