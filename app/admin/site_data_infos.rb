ActiveAdmin.register SiteDataInfo do

  actions :index, :show

  filter :id
  filter :test_id
  filter :url_id
  filter :cloudflare, :as => :select, :collection => SiteDataInfo::STATUS.invert


  index do 
    column "Test" do |site_data|
      link_to site_data.test.id, admin_test_path(site_data.test)
    end
    column "Url" do |site_data|
      link_to "#{site_data.url.id}:  #{site_data.url.url}", admin_url_path(site_data.url)
    end 
    column 'All Tests' do |site_data|
      link_to 'all_tests', admin_site_data_infos_path('q[url_id_equals]' => site_data.url_id)
    end
    column 'Plugins' do |site_data|
      plugins = site_data.plugins
      if JSON::parse(plugins).size > 0
        link_to 'plugins', admin_plugins_path("q[url_id_equals]" => site_data.url_id, "q[status_equals]" => 1)
      else
        div("plugin not found", style: "color: red")
      end
    end
    column 'Themes' do |site_data|
      themes = site_data.themes
      if JSON::parse(themes).size > 0
        link_to 'Themes', admin_themes_path("q[url_id_equals]" => site_data.url_id, "q[status_equals]" => 1)
      else
        div("Theme not found", style: "color: red")
      end
    end

    column 'Js' do |site_data|
      js = site_data.js
      if JSON::parse(js).size > 0
        link_to 'Js', admin_js_infos_path("q[url_id_equals]" => site_data.url_id, "q[status_equals]" => 1)
      else
        div("js not found", style: "color: red")
      end
    end
    column 'Wordpress Version' do |site_data|
      version = site_data.cms_version
      if version == 'Version not found'
        div (version), :style => "color : red"
      else
        version
      end
    end
    column 'Cloudflare' do |site|
      if site.cloudflare == '0'
        div (SiteDataInfo::STATUS[site.cloudflare]),style: "color: red"
      elsif site.cloudflare =='1'
        div (SiteDataInfo::STATUS[site.cloudflare]),style: "color: green"
      end
    end
  end

  show do
    attributes_table do
      row :id
      row 'url' do |site|
        link_to "#{site.url.id}:: #{site.url.url}", admin_url_path(site.url) 
      end
      row :test
      row :cms_type
      row :cms_version
      row 'Versions' do |site_data|
        link_to 'versions', admin_site_data_infos_path('q[url_id_equals]' => site_data.url_id)
      end
      row "Plugins" do |site|
        link_to 'plugins', admin_plugins_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
      end
      row "Themes" do |site|
        link_to 'themes', admin_themes_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
      end
      row "Js" do |site|
        link_to 'js', admin_js_infos_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
      end
      row 'Cloudflare' do |site|
        div (SiteDataInfo::STATUS[site.cloudflare])
      end
    end
  end
end
