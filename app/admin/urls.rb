ActiveAdmin.register Url do

  batch_action :run_test do |ids|
    redirect_to run_test_admin_url_path(ids)
  end

  actions :index, :show

  filter :id
  filter :url
  filter :created_at
  filter :updated_at
  filter :first_seen 
  scope :all
  scope :wordpress_sites, :default => true do |urls|
    urls.where.not(:cms => nil) 
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
      version = url.site_data_infos.last.cms_version if url.site_data_infos.last.present?
      if version
        div (version)
      else
        if url.cms.present?
          div 'not found', :style => "color : red"
        else
          div 'not a wordpress site'
        end
      end
    end
    column 'Last Test' do |url|
      if url.site_data_infos.last
        link_to "Test #{url.site_data_infos.last.test_id}", admin_test_path(url.site_data_infos.last.test_id)
      end
    end
    column 'Last Test Data' do |url|
      if url.site_data_infos.last
        link_to "last test data info", admin_site_data_infos_path("q[test_id_equals]" => url.site_data_infos.last.test_id, 
                                                                  "q[url_id_equals]" => url.site_data_infos.last.url_id)
      end
    end
    column 'Run New Test' do |url|
      link_to "run test", run_test_admin_url_path(url)
    end
  end

  show do 
    attributes_table do
      row :id
      row 'Url' do |url|
        link_to url.url, "http://www.#{url.url}", :target => '_blank'
      end
      if url.site_data_infos.last
        link_to 'Versions', admin_site_data_infos_path('q[url_id_equals]' => url.id)
      end
      row 'WP Version' do |url|
        version = url.site_data_infos.last.cms_version
        if version == nil
          div ("Not found"), :style => "color : red"
        else
          version
        end
      end
      row 'Plugins' do |url|
        plugins = url.site_data_infos.last.plugins
        if plugins.present?
          link_to 'Plugins', admin_plugins_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'Themes' do |url|
        themes = url.site_data_infos.last.themes
        if themes.present?
          link_to 'Themes', admin_themes_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'Js' do |url|
        js = url.site_data_infos.last.js
        if js.present?
          link_to 'Js', admin_js_infos_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'Cloudflare' do |url|
        site_data = url.site_data_infos.last
        status = site_data.cloudflare ? "ACTIVE" : "INACTIVE"
        color = site_data.cloudflare ? "green" : "red"
        div status, :style => "color : #{color}"
      end
      row 'Last Test Data' do |url|
        if url.site_data_infos.last
          link_to "last test data info", admin_site_data_infos_path("q[test_id_equals]" => url.site_data_infos.last.test_id,
                                                                    "q[url_id_equals]" => url.site_data_infos.last.url_id)
        end
      end
      row 'Last Test' do |url|
        if url.site_data_infos.last
          link_to "Test #{url.site_data_infos.last.test_id}", admin_test_path(url.site_data_infos.last.test_id)
        end
      end
      row 'Changes' do |url|
        link_to 'check', test_comparison_admin_url_path(url)
      end
      row 'Run New Test' do |url|
        link_to "run test", run_test_admin_url_path(url)
      end
    end
  end
  member_action :test_comparison, :method => [:get, :post]
  member_action :run_test, :method => :get do 
    ids = params["id"].split('/')
    raise "please select at least one url" if ids.count == 0
    urls = Url.where(:id => ids).pluck(:url)
    test = Test.create!(:number_of_urls => urls.size, :status => Test::Status::INITIALIZED)
    TestInitializeJob.perform_later(urls, test.id)
    flash[:notice] = "Test has been started"
    redirect_to admin_urls_path
  rescue => e
    flash[:error] = e.message
    redirect_to admin_urls_path
  end
end
