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
              h3 "No.", :class => 'active_admin_test_running_label'
              h3 "Test", :class => 'active_admin_test_running_label'
              h3 "Started_at", :class => 'active_admin_test_running_label'
              h3 "Total Jobs", :class => 'active_admin_test_running_label'
              h3 "Completed Jobs", :class => 'active_admin_test_running_label'
              h3 "Running Time", :class => 'active_admin_test_running_label'
              hr
            end
            tests = Test.where(:status => Test::STATUS.invert[:RUNNING]).all
            i = 1
            if tests.count > 0
              tests.each do |test|
                total = Step.where(:test_id => test.id).count
                completed = Step.where(:test_id => test.id, :status => Step::STATUS.invert[:COMPLETED]).count

                div :class => 'running_tests' do
                  div i, :class => 'active_admin_test_running_content'
                  a "Test #{test.id} is running",href: admin_tests_path('q[id_equals]' => test.id), 
                    :class => 'active_admin_test_running_content', 
                    :style => 'color : orange'
                  div test.created_at, :class => 'active_admin_test_running_content'
                  div total, :class => 'active_admin_test_running_content'
                  # div Step.where(:test_id => test.id).count, :class => 'active_admin_test_running_lable'
                  div completed, :class => 'active_admin_test_running_content'

                  div " #{Integer(Time.now - test.created_at)/60} min #{Integer(Time.now - test.created_at)%60} sec ",
                    :class => 'active_admin_test_running_content'

                  #div Step.where(:test_id => test.id, :status => Step::STATUS.invert[:RUNNING]).count, :class => 'active_admin_test_running_lable'
                  br
                end
                i += 1
              end
            else
              div "no running tests", :class => 'active_admin_test_running_content'
            end
          end

          panel 'Completed Tests' do
            div :class => 'completed_tests' do 
              span "No.", :class => 'active_admin_test_completed_label'
              span "Test", :class => 'active_admin_test_completed_label'
              span "Total Sites", :class => 'active_admin_test_completed_label'
              span "Started_at", :class => 'active_admin_test_completed_label'
              span "Ended_at", :class => 'active_admin_test_completed_label'
              span "Time Taken", :class => 'active_admin_test_completed_label'
              br
            end
            tests = Test.where(:status => Test::STATUS.invert[:COMPLETED]).last(5)
            i = 1
            tests.reverse.each do |test|
              div :class => 'completed_tests' do
                div i, :class => 'active_admin_test_completed_content'
                a "Test #{test.id}",href: admin_tests_path('q[id_equals]' => test.id), 
                  :class => 'active_admin_test_completed_content'
                div test.number_of_urls, :class => 'active_admin_test_completed_content'
                div test.created_at, :class => 'active_admin_test_completed_content'
                div test.updated_at, :class => 'active_admin_test_completed_content'
                div (" #{Integer(test.updated_at - test.created_at)/60} min #{Integer(test.updated_at - test.created_at)%60} sec "), 
                     :class => 'active_admin_test_completed_content'
                br
              end
              i += 1
            end
          end
        end
      end
    end

  end


=begin
  action_item :view do
    if Test.last != nil
      if  Test.last.status == Test::STATUS.invert[:COMPLETED]
        link_to " Test #{ Test.last.id } has been Completed", 
          admin_site_data_infos_path('q[test_id_equals]' => Test.last.id), 
          :style => "color : darkgreen"
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
        link_to "#{ completed } / #{ total } jobs completed", admin_steps_path('q[status_eq]' => '1'), :style => "color : dark-blue"
      end
    end
  end
=end

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
