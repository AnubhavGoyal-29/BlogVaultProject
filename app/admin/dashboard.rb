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



  action_item :view do
    if Test.last != nil
      if  Test.last.status == '1'
        link_to " Test #{ Test.last.id } is #{ Test::STATUS[Test.last.status]}", 
          admin_site_data_infos_path('q[test_id_equals]' => Test.last.id), 
          :style => "color : darkgreen", :class => "btn-primary"
      else
        link_to " Test #{ Test.last.id } is #{ Test::STATUS[Test.last.status]}",
          admin_site_data_infos_path('q[test_id_equals]' => Test.last.id),
          :style => "color : dark-blue"
      end
    end
  end

  action_item :view do 
    if Test.last != nil
      total = Step.where(:test_id => Test.last.id).count
      completed = Step.where(:test_id => Test.last.id, :status => 2).count
      if completed != total
        link_to "#{ completed } / #{ total } completed", admin_steps_path('q[status_eq]' => '1'), :style => "color : green"
      end
    end
  end


  # first it will add new wordpress site to database 
  # then run the test for all urls
  page_action :start_test, :method => [:post,:get] do
    urls = []
    if params[:start_test][:file]
      File.readlines(params[:start_test][:file].tempfile, chomp: true).each do |line|
        # to remove last character '/n'
        urls.append(line)
      end
    end
    TestInitializeJob.perform_later(urls)
    flash[:notice] = "test has been started"
    redirect_to admin_dashboard_path
  end
end
