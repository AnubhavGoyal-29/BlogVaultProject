ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }
  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Input File" do
          render :partial => "form"
        end
      end
    end

    columns do
      column do
        panel 'Test Info' do 
          panel 'Running Tests' do
            div :class => 'running_tests' do
              h3 "Test", :class => 'active_admin_test_running_label'
              h3 "Started at", :class => 'active_admin_test_running_label'
              h3 "Total Jobs", :class => 'active_admin_test_running_label'
              h3 "Completed Jobs", :class => 'active_admin_test_running_label'
              h3 "Running Time", :class => 'active_admin_test_running_label'
              hr
            end
            tests = V2::Test.running.to_a
            if tests.present?
              tests.each do |test|
                total = V2::Step.where(:test => test)
                completed = total.completed
                time = ActiveSupport::Duration.build(Time.now - test.started_at).parts
                div :class => 'running_tests' do
                  div "Test #{test.number} is running",
                    :class => 'active_admin_test_running_content', 
                    :style => 'color : orange'
                  div test.started_at, :class => 'active_admin_test_running_content'
                  div total.count, :class => 'active_admin_test_running_content'
                  div completed.count, :class => 'active_admin_test_running_content'
                  div "#{time[:minutes]} min #{time[:seconds].round(0)} sec",
                    :class => 'active_admin_test_running_content'
                  hr
                end
              end
            else
              div "no running tests", :class => 'active_admin_test_running_content'
            end
          end
          panel 'Completed Tests' do
            div :class => 'completed_tests' do 
              span "Test", :class => 'active_admin_test_completed_label'
              span "Total Sites", :class => 'active_admin_test_completed_label'
              span "Succeed Jobs", :class => 'active_admin_test_completed_label'
              span "Failed Jobs", :class => 'active_admin_test_completed_label'
              span "Started at", :class => 'active_admin_test_completed_label'
              span "Time Taken", :class => 'active_admin_test_completed_label'
              hr
            end
            tests = V2::Test.completed.to_a.last(5)
            if tests.present?
              tests.reverse.each do |test|
                total = V2::Step.where(:test => test)
                succeed = total.succeed
                failed = total.failed
                time = ActiveSupport::Duration.build(test.updated_at - test.started_at).parts
                div :class => 'completed_tests' do
                  a "Test #{test.number}",href: admin_tests_path('q[id_equals]' => test.id), 
                    :class => 'active_admin_test_completed_content'
                  div test.number_of_websites, :class => 'active_admin_test_completed_content'
                  div succeed.count, :class => 'active_admin_test_completed_content'
                  div failed.count, :class => 'active_admin_test_completed_content'
                  div test.started_at, :class => 'active_admin_test_completed_content'
                  div "#{time[:minutes]} min #{time[:seconds].round(0)} sec",
                    :class => 'active_admin_test_running_content'
                  hr
                end
              end
            else 
              div "no recorded test", :class => 'active_admin_test_running_content'
            end
          end
        end
      end
    end
  end

  action_item :history do
    link_to 'History', frontend_source_timeline_path(:status => true)
  end

  action_item :cms do
    link_to 'CMS', frontend_cms_distribution_path(:status => true)
  end

  action_item :site_timeline do
    link_to 'Site', frontend_site_timeline_path(:status => true)
  end

  # first it will add new wordpress site to database 
  # then run the test for all urls
  page_action :start_test, :method => [:post, :get] do
    if params[:start_test] && params[:start_test][:file]
      urls = File.readlines(params[:start_test][:file].tempfile, chomp: true)
      test = V2::Test.create!(:number_of_websites => urls.size, :status => V2::Test::Status::INITIALIZED, 
                              :number => V2::Test.last.present? ? V2::Test.last.number + 1 : 1)
      TestInitializeJob.perform_later(urls, test.id.to_s)
      flash[:notice] = "test #{test.id.to_s} has been started"
      redirect_to admin_dashboard_path
    else
      flash[:alert] = "please input a csv file to get started"
      redirect_to admin_dashboard_path
    end
  end
end
