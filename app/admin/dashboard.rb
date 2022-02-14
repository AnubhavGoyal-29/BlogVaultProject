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
    link_to 'Start test', admin_dashboard_start_test_path
  end


  # only configured for csv file
  # first it will add new wordpress site to database 
  # then run the test for all urls
  page_action :start_test, :method => [:post,:get] do

    urls = []
    if params[:start_test][:file]
      File.open(params[:start_test][:file].tempfile).each do |line|
        urls.append(line.first(line.size-1))
      end
    end

    test = Test.create(number_of_urls: urls.size,status:0)

    # to run 10 workers dividing the files in size of 10
    chunk_size = (urls.size + (urls.size % 10) )/ 10
    urls.in_groups_of(chunk_size+1){ |_urls|
        BlogvaultScrapingJob.perform_later(_urls,test.id)
    }

    redirect_to admin_dashboard_path
  end
end
