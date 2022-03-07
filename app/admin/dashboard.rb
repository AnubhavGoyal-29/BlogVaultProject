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
            tests = Test.where(:status => Test::Status::RUNNING).all
            if tests.count > 0
              tests.each do |test|
                total = Step.where(:test_id => test.id).count
                running = Step.where(:test_id => test.id, :status => Test::Status::RUNNING).count             
                initialized = Step.where(:test_id => test.id, :status => Test::Status::INITIALIZED).count
                div :class => 'running_tests' do
                  div "Test #{test.id} is running",
                    :class => 'active_admin_test_running_content', 
                    :style => 'color : orange'
                  div test.started_at, :class => 'active_admin_test_running_content'
                  div total, :class => 'active_admin_test_running_content'
                  div (total - running - initialized), :class => 'active_admin_test_running_content'
                  div " #{Integer(Time.now - test.started_at)/60} min #{Integer(Time.now - test.started_at)%60} sec ",
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
            tests = Test.where(:status => Test::Status::COMPLETED).last(5)
            if tests.count > 0
              tests.reverse.each do |test|
                succeed = Step.where(:test_id => test.id, :status => Test::Status::COMPLETED).count
                failed = Step.where(:test_id => test.id, :status => Test::Status::FAILED).count
                div :class => 'completed_tests' do
                  a "Test #{test.id}",href: admin_tests_path('q[id_equals]' => test.id), 
                    :class => 'active_admin_test_completed_content'
                  div test.number_of_urls, :class => 'active_admin_test_completed_content'
                  div succeed, :class => 'active_admin_test_completed_content'
                  div failed, :class => 'active_admin_test_completed_content'
                  div test.started_at, :class => 'active_admin_test_completed_content'
                  div (" #{Integer(test.updated_at - test.started_at)/60} min #{Integer(test.updated_at - test.started_at)%60} sec "), 
                    :class => 'active_admin_test_completed_content'
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

  # first it will add new wordpress site to database 
  # then run the test for all urls
  page_action :start_test, :method => [:post, :get] do
    urls = []
    if params[:start_test] && params[:start_test][:file]
      File.readlines(params[:start_test][:file].tempfile, chomp: true).each do |line|
        urls.append(line)
      end
      test = Test.create!(:number_of_urls => urls.size, :status => Test::Status::INITIALIZED)
      TestInitializeJob.perform_later(urls, test.id)
      flash[:notice] = "test #{test.id} has been started"
      redirect_to admin_dashboard_path
    else
      flash[:alert] = "please input a csv file to get started"
      redirect_to admin_dashboard_path
    end
  end
end
