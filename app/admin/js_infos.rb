ActiveAdmin.register_page "Js_Infos" do
  sidebar :filters do
    render partial: 'filter'
  end


  content do 
    args = {}
    if params["q"]
      args[:id.in] = params["q"]["id_in"] if params["q"]["id_in"].present?
      args[:website_id] = params["q"]["website_id_equals"] if params["q"]["website_id_equals"].present?
    end
    manual_checks = ["created_from", "created_to", "updated_from", "updated_to"]
    time_frame = {:created_at => ["created_from", "created_to"], :updated_at => ["updated_from", "updated_to"]}
    sidebar_filters = params["sidebar_filters"]
    if sidebar_filters.present?
      sidebar_filters.each do |key, value|
        if !manual_checks.include?key and value.present?
          args[key] = value
        end
      end
      time_frame.each do |key, value|
        from = sidebar_filters[value[0]].present? ? sidebar_filters[value[0]] : V2::Test.first.created_at
        to = sidebar_filters[value[1]].present? ? sidebar_filters[value[1]] : Time.now
        args[key] = from..to
      end
    end

    panel "Js Info" do
      table_for V2::JsInfo.where(args).limit(50) do

        column :id
        column :js_lib, :style => "width : 300px"
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
          website_ids = V2::JsInfo.where(args).pluck(:website_id)
          link_to "#{website_ids.count} :: urls", admin_websites_path("q[id_in]" => website_ids), "data-method" => :post
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

    end
  end
end

