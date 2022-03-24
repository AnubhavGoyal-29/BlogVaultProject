ActiveAdmin.register Website do

  batch_action :run_test do |ids|
    redirect_to run_test_admin_website_path(ids)
  end

  actions :index, :show

  filter :id
  filter :website
  filter :created_at
  filter :updated_at
  filter :first_seen 
  scope :all
  scope :wordpress_sites, :default => true do |websites|
    websites.where.not(:cms => nil) 
  end

  index do |website|
    selectable_column
    id_column
    column 'Url' do |website|
      link_to website.url, "http://www.#{website.url}", :target => '_blank'
    end
    column 'All Versions' do |website|
      if website.site_data_infos.last
        link_to 'Versions', admin_site_data_infos_path('q[website_id_equals]' => website.id)
      end
    end
    column 'WP Version' do |website|
      version = website.site_data_infos.last.cms_version if website.site_data_infos.last.present?
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
      if website.site_data_infos.last
        link_to "Test #{website.site_data_infos.last.test_id}", admin_tests_path(website.site_data_infos.last.test_id)
      end
    end
    column 'Last Test Data' do |website|
      if website.site_data_infos.last
        link_to "last test data info", admin_site_data_infos_path("q[test_id_equals]" => website.site_data_infos.last.test_id, 
                                                                  "q[website_id_equals]" => website.site_data_infos.last.website_id)
      end
    end
    column 'Run New Test' do |website|
      link_to "run test", run_test_admin_website_path(website)
    end
  end

  show do 
    attributes_table do
      row :id
      row 'Url' do |website|
        link_to website.url, "http://www.#{website.url}", :target => '_blank'
      end
      if website.site_data_infos.last
        link_to 'Versions', admin_site_data_infos_path('q[website_id_equals]' => website.id)
      end
      row 'WP Version' do |website|
        version = website.site_data_infos.last.cms_version
        if version == nil
          div ("Not found"), :style => "color : red"
        else
          version
        end
      end
      row 'Plugins' do |website|
        plugins = website.site_data_infos.last.plugin_ids
        if plugins.present?
          link_to 'Plugins', admin_plugins_path("q[website_id_equals]" => website.id, "q[status_equals]" => 1)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'Themes' do |website|
        themes = website.site_data_infos.last.theme_ids
        if themes.present?
          link_to 'Themes', admin_themes_path("q[website_id_equals]" => website.id, "q[status_equals]" => 1)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'Js' do |website|
        js = website.site_data_infos.last.js_ids
        if js.present?
          link_to 'Js', admin_js_infos_path("q[website_id_equals]" => website.id, "q[status_equals]" => 1)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'Cloudflare' do |website|
        site_data = website.site_data_infos.last
        status = site_data.cloudflare ? "ACTIVE" : "INACTIVE"
        color = site_data.cloudflare ? "green" : "red"
        div status, :style => "color : #{color}"
      end
      row 'Last Test Data' do |website|
        if website.site_data_infos.last
          link_to "last test data info", admin_site_data_infos_path("q[test_id_equals]" => website.site_data_infos.last.test_id,
                                                                    "q[website_id_equals]" => website.site_data_infos.last.website_id)
        end
      end
      row 'Last Test' do |website|
        if website.site_data_infos.last
          link_to "Test #{website.site_data_infos.last.test_id}", admin_tests_path(website.site_data_infos.last.test_id)
        end
      end
      row 'Changes' do |website|
        link_to 'check', test_comparison_admin_website_path(website)
      end
      row 'Run New Test' do |website|
        link_to "run test", run_test_admin_website_path(website)
      end
    end
  end
  member_action :test_comparison, :method => [:get, :post]
  member_action :run_test, :method => :get do 
    ids = params["id"].split('/')
    raise "please select at least one website" if ids.count == 0
    websites = Website.where(:id => ids).pluck(:url)
    test = Test.create!(:number_of_websites => websites.size, :status => Test::Status::INITIALIZED)
    TestInitializeJob.perform_later(websites, test.id)
    flash[:notice] = "Test has been started"
    redirect_to admin_websites_path
  rescue => e
    flash[:error] = e.message
    redirect_to admin_websites_path
  end
end
