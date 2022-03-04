ActiveAdmin.register Url do

  permit_params :url

  batch_action :run_test do |ids|
    redirect_to run_test_admin_url_path(ids)
  end

  actions :index, :show

  filter :id
  filter :url

  scope :all
  scope :wordpress_sites, :default => true do |urls|
    urls.where.not(:site_data_info_id => nil) 
  end

  index do |url|
    selectable_column
    id_column
    column 'Url' do |url|
      link_to url.url, "http://www.#{url.url}", :target => '_blank'
    end
    column 'All Versions' do |url|
      if url.site_data_infos.last
        link_to 'Versions', admin_site_data_infos_path('q[url_id_equals]' => url.id)
      end
    end
    column 'WP Version' do |url|
      version = url.site_data_infos.last ? url.site_data_infos.last.cms_version : 'not a wordpress site'
      if version == 'version not found'
        div ("Not found"), :style => "color : red"
      else
        version
      end
    end
    column 'Last Test' do |url|
      if url.site_data_infos.last
        link_to "Test #{url.site_data_infos.last.test_id}", admin_test_path(url.site_data_infos.last.test_id)
      end
    end
    column 'Last Test Data' do |url|
      if url.site_data_infos.last
        link_to "last_test_data_info", admin_site_data_infos_path("q[test_id_equals]" => url.site_data_infos.last.test_id, 
            "q[url_id_equals]" => url.site_data_infos.last.url_id)
      end
    end
    column 'Run New Test' do |url|
      link_to "run_test", run_test_admin_url_path(url)
    end
  end

  show do 
    attributes_table do
      row 'Url' do |url|
        link_to url.url, "http://www.#{url.url}", :target => '_blank'
      end
      row 'Versions' do |url|
        link_to 'Versions', admin_site_data_infos_path('q[url_id_equals]' => url.id)
      end
      row 'WP Version' do |url|
        version = url.site_data_infos.last.cms_version
        if version == 'version not found'
          div ("Not found"), :style => "color : red"
        else
          version
        end
      end
      row 'Plugins' do |url|
        plugins = url.site_data_infos.last.plugins
        if JSON::parse(plugins).size > 0
          link_to 'Plugins', admin_plugins_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'Themes' do |url|
        themes = url.site_data_infos.last.themes
        if JSON::parse(themes).size > 0
          link_to 'Themes', admin_themes_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'Js' do |url|
        link_to 'JS', admin_js_infos_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
      end
      row 'Cloudflare' do |url|
        cloudflare = url.site_data_infos.last.cloudflare
        if cloudflare == '0'
          div (SiteDataInfo::STATUS[cloudflare]),style: "color: red"
        elsif cloudflare =='1'
          div (SiteDataInfo::STATUS[cloudflare]),style: "color: green"
        end
      end
      row 'Last Test Data' do |url|
        link_to "last_test_data_info", admin_site_data_info_path(url.site_data_info_id)
      end
      row 'Last Test' do |url|
        link_to "Test #{url.site_data_infos.last.test_id}", admin_tests_path("q[id_equals]" => url.site_data_infos.last.test_id)
      end
      row 'Changes' do |url|
        link_to 'check', test_select_form_admin_url_path(url)
      end
    end
  end
  member_action :test_select_form, :method => [:get, :post]
  member_action :run_test, :method => :get do 
    ids = params["id"].split('/')
    raise "please select at least one url" if ids.count == 0
    urls = Url.where(:id => ids).pluck(:url)
    test = Test.create!(:number_of_urls => urls.size, :status => Test::Status::RUNNING)
    TestInitializeJob.perform_later(urls)
    flash[:notice] = "Test has been started"
    redirect_to admin_urls_path
  rescue => e
    flash[:error] = e.message
    redirect_to admin_urls_path
  end
end
