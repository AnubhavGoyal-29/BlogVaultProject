ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }
  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end
    columns do
      column do
        panel "Input File" do
          render :partial => "form"
        end
      end
    end
  end
  # action_item :view, :only =>[:show] do
  #  link_to 'Modify_Table', modify_data_admin_dashboard_path(resource)
  #end
  controller do
  end
  action_item :view do
    link_to 'Enable Speed', admin_dashboard_enable_speed_path, data: {:confirm => "Are you sure?"}
  end

  page_action :enable_speed, :method => :post do
    urls = []
    if params[:enable_speed][:file]
      File.open(params[:enable_speed][:file].tempfile).each do |line|
        urls.append(line.first(line.size-1))
    end
    end
    if params[:enable_speed][:text]
      #some code here 
    end
    BlogVaultScrape(urls)
  end
end
