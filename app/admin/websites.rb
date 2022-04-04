ActiveAdmin.register_page "Websites" do

  #action_item :run_test do |ids|
  #redirect_to run_test_admin_website_path(ids)
  #end

  sidebar :filters, if: proc{ !params["show_page"].present? } do
    render partial: 'filter'
  end

  sidebar :scopes, if: proc{ !params["show_page"].present? } do
    render partial: 'filter'
  end

  content do
    args = {}
    args[:cms.in] = V2::Website::cms
    if params["q"] and params["q"]["id_in"].present?
      args[:id.in] = params["q"]["id_in"]
    end
    manual_checks = ["created_from", "created_to", "updated_from", "updated_to"]
    time_frame = {:created_at => ["created_from", "created_to"], :updated_at => ["updated_from", "updated_to"]}
    sidebar_filters = params["sidebar_filters"]
    if sidebar_filters.present?
      sidebar_filters.each do |key, value|
        if !manual_checks.include?key and value.present?
          if key == "url"
            args[key] = /.*#{value}.*/
          else
            args[key] = value
            end
        end
      end
      time_frame.each do |key, value|
        from = sidebar_filters[value[0]].present? ? sidebar_filters[value[0]] : V2::Test.first.created_at
        to = sidebar_filters[value[1]].present? ? sidebar_filters[value[1]] : Time.now
        args[key] = from..to
      end
    end
    if !params["show_page"].present?
      panel "Websites" do
        table_for V2::Website.where(args).to_a do
          latest_site_data_info = {}
          column "Id" do |website|
            latest_site_data_info[website.id.to_s] = V2::SiteDataInfo.where(:website => website).last
            link_to website.id, admin_websites_path(:id => website.id, :show_page => true)
          end
          column 'Url' do |website|
            link_to website.url, "http://www.#{website.url}", :target => '_blank'
          end
          column 'All Versions' do |website|
            if latest_site_data_info[website.id.to_s].present?
              link_to 'Versions', admin_site_data_infos_path('q[website_id_equals]' => website.id.to_s)
            end
          end
          column 'WP Version' do |website|
            version = latest_site_data_info[website.id.to_s].cms_version if latest_site_data_info[website.id.to_s].present?
            if version
              div (version)
            else
              if website.cms.present?
                div 'not found', :style => "color : red"
              else
                div 'not a wordpress site'
              end
            end
          end
          column 'Last Test' do |website|
            if latest_site_data_info[website.id.to_s].present?
              link_to "Test #{latest_site_data_info[website.id.to_s].test.number}", 
                admin_tests_path(latest_site_data_info[website.id.to_s].test.number)
            end
          end
          column 'Last Test Data' do |website|
            if latest_site_data_info[website.id.to_s].present?
              link_to "last test data info", admin_site_data_infos_path("q[test_id_equals]" => latest_site_data_info[website.id.to_s].test_id.to_s, 
                                                                        "q[website_id_equals]" => latest_site_data_info[website.id.to_s].website_id.to_s)
            end
          end
          column 'Run New Test' do |website|
            link_to "run test", admin_websites_run_test_path(:id => website.id.to_s)
          end
        end
      end
    else
      website = V2::Website.find(params[:id])
      latest_site_data = V2::SiteDataInfo.where(:website => website).last
      panel website.url do
        attributes_table_for website do

          row 'Url' do 
            link_to website.url, "http://www.#{website.url}", :target => '_blank'
          end
          row 'All Versions' do 
            if latest_site_data.present?
              link_to 'Versions', admin_site_data_infos_path('q[website_id_equals]' => website.id.to_s)
            end
          end
          row 'WP Version' do 
            version = latest_site_data.cms_version if latest_site_data.present?
            if version
              div (version)
            else
              if website.cms.present?
                div 'not found', :style => "color : red"
              else
                div 'not a wordpress site'
              end
            end
          end
          row 'Last Test' do |website|
            if latest_site_data.present?
              link_to "Test #{latest_site_data.test.number}", 
                admin_tests_path(latest_site_data.test.number)
            end
          end
          row 'Last Test Data' do |website|
            if latest_site_data.present?
              link_to "last test data info", admin_site_data_infos_path("q[test_id_equals]" => latest_site_data.test_id.to_s, 
                                                                        "q[website_id_equals]" => latest_site_data.website_id.to_s)
            end
          end
          row 'Run New Test' do |website|
            link_to "run test", admin_websites_run_test_path(:id => website.id.to_s)
          end

          row 'Compare Test' do |website|
            link_to "compare now", admin_websites_test_comparison_path(website)
          end

        end
      end
 
    end
  end
  page_action :test_comparison, :method => [:get, :post]
  page_action :run_test, :method => :get do
    ids = params["id"].split('/')
    raise "please select at least one website" if ids.count == 0
    websites = V2::Website.in(:id => ids).pluck(:url)
    test = V2::Test.create!(:number_of_websites => websites.size, :status => Test::Status::INITIALIZED,
                            :number => V2::Test.last.present? ? V2::Test.last.number + 1 : 1)
    TestInitializeJob.perform_later(websites, test.id.to_s)
    flash[:notice] = "Test has been started"
    redirect_to admin_websites_path
  rescue => e
    flash[:error] = e.message
    redirect_to admin_websites_path
  end
end
