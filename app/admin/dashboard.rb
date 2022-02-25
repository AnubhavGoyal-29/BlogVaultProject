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
              span "sr.no", :class => 'active_admin_test_running_label'
              span "test", :class => 'active_admin_test_running_label'
              span "started_at", :class => 'active_admin_test_running_label'
              span "total jobs", :class => 'active_admin_test_running_label'
              span "jobs completed", :class => 'active_admin_test_running_label'
              span "running time", :class => 'active_admin_test_running_label'
              br
            end
            tests = Test.where(:status => Test::STATUS.invert[:RUNNING]).all
            i = 1
            if tests.count > 0
              tests.each do |test|
                total = Step.where(:test_id => test.id).count
                completed = Step.where(:test_id => test.id, :status => Step::STATUS.invert[:COMPLETED]).count

                div :class => 'running_tests' do
                  div i, :class => 'active_admin_test_running_label'
                  a "Test #{test.id} is running",href: admin_tests_path('q[id_equals]' => test.id), 
                    :class => 'active_admin_test_running_label', 
                    :style => 'color : orange'
                  div test.created_at, :class => 'active_admin_test_running_label'
                  div total, :class => 'active_admin_test_running_label'
                  # div Step.where(:test_id => test.id).count, :class => 'active_admin_test_running_lable'
                  div completed, :class => 'active_admin_test_running_label'

                  div " #{Integer(Time.now - test.created_at)/60}minutes #{Integer(Time.now - test.created_at)%60}seconds ",
                    :class => 'active_admin_test_running_label'

                  #div Step.where(:test_id => test.id, :status => Step::STATUS.invert[:RUNNING]).count, :class => 'active_admin_test_running_lable'
                  br
                end
                i += 1
              end
            else
              div "no running tests", :class => 'active_admin_test_running_label'
            end
          end

          panel 'Completed Tests' do
            div :class => 'completed_tests' do 
              span "sr.no", :class => 'active_admin_test_completed_label'
              span "test", :class => 'active_admin_test_completed_label'
              span "total urls", :class => 'active_admin_test_completed_label'
              span "started_at", :class => 'active_admin_test_completed_label'
              span "ended_at", :class => 'active_admin_test_completed_label'
              span "time taken", :class => 'active_admin_test_completed_label'
              br
            end
            tests = Test.where(:status => Test::STATUS.invert[:COMPLETED]).last(5)
            i = 1
            tests.reverse.each do |test|
              div :class => 'completed_tests' do
                div i, :class => 'active_admin_test_completed_label'
                a "Test #{test.id}",href: admin_tests_path('q[id_equals]' => test.id), 
                  :class => 'active_admin_test_completed_label'
                div test.number_of_urls, :class => 'active_admin_test_completed_label'
                div test.created_at, :class => 'active_admin_test_completed_label'
                div test.updated_at, :class => 'active_admin_test_completed_label'
                div (" #{Integer(test.updated_at - test.created_at)/60}minutes #{Integer(test.updated_at - test.created_at)%60}seconds "), 
                  :class => 'active_admin_test_completed_label'
                br
              end
              i += 1
            end
          end
        end
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
