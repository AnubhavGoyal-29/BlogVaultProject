ActiveAdmin.register Url do

    permit_params :url
  actions :index, :show
  filter :id
  filter :url
  scope :all
  scope :wordpress_sites, :default => true do |urls|
    urls.where.not(:site_data_info_id => nil) 
  end
  index do |url|
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
    column 'LastTest' do |url|
      if url.site_data_infos.last
        link_to "Test #{url.site_data_infos.last.test_id}", admin_test_path(url.site_data_infos.last.test_id)
      end
    end
    column 'LastTestData' do |url|
      if url.site_data_infos.last
        link_to "LastTestdataInfo", admin_site_data_infos_path("q[test_id_equals]" => url.site_data_infos.last.test_id, "q[url_id_equals]" => url.site_data_infos.last.url_id)
      end
    end

    column "select" do |url|
      check_box_tag "skdnf"
    end 

        actions defaults: true do |role|
        end

  end

 form do |f|
    f.inputs "Add/Edit Role" do
      f.input :user_id,  :as => :select, :collection => User.all
      f.input :role_id, :as => :check_boxes, :collection => Role.all
    end
    actions
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
        link_to "LastTestDataInfo", admin_site_data_info_path(url.site_data_info_id)
      end
      row 'LastTest' do |url|
        link_to "Test #{url.site_data_infos.last.test_id}", admin_tests_path("q[id_equals]" => url.site_data_infos.last.test_id)
      end
      row 'Changes' do |url|
        link_to 'check', test_select_form_admin_url_path(url)
      end
    end
  end
  member_action :test_select_form, :method => [:get, :post]
  member_action :compare_test_form, :method => [:get, :post] do
    render :partial => "compare_test_form" , :locals => {:test1 => params["test_select_form"]["test1"], :test2 => params["test_select_form"]["test2"]}
  end
end
