ActiveAdmin.register Url do
  actions :index, :show

  filter :id
  filter :site_data_infos_last_id
  controller do 
    def scoped_collection
      Url.site_data_info
    end
  end
  index do
    column :id
    column 'All Versions' do |url|
      link_to 'versions', admin_site_data_infos_path('q[url_id_equals]' => url.id)
    end
    column :url
    column 'Plugins' do |url|
      plugins = url.site_data_infos.last.plugins
      if JSON::parse(plugins).size > 0
        link_to 'plugins', admin_plugins_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
      else
        div("not found", style: "color: red")
      end
    end
    column 'Wordpress Version' do |url|
      version = url.site_data_infos.last.cms_version
      if version == 'Version not found'
        div (url.site_data_infos.last.cms_version), :style => "color : red"
      else
        version
      end
    end
    column 'Themes' do |url|
      themes = url.site_data_infos.last.themes
      if JSON::parse(themes).size > 0
        link_to 'themes', admin_themes_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
      else
        div("not found", style: "color: red")
      end
    end
    column 'Js' do |url|
      link_to 'js_info', admin_js_infos_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
    end
    column 'Cloudflare' do |url|
      cloudflare = url.site_data_infos.last.cloudflare
      if cloudflare == '0'
        div (SiteDataInfo::STATUS[cloudflare]),style: "color: red"
      elsif cloudflare =='1'
        div (SiteDataInfo::STATUS[cloudflare]),style: "color: green"
      end
    end
    column 'LastTest' do |url|
      link_to "Test #{url.site_data_infos.last.test_id}", admin_tests_path("q[id_equals]" => url.site_data_infos.last.test_id)
    end
  end

  show do 
    attributes_table do
      row 'All Tests' do |url|
        link_to 'all_test', admin_site_data_infos_path('q[url_id_equals]' => url.id)
      end
      row :url
      row 'Plugins' do |url|
        plugins = url.site_data_infos.last.plugins
        if JSON::parse(plugins).size > 0
          link_to 'plugins', admin_plugins_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
        else
          div("plugin not found", style: "color: red")
        end
      end
      row 'Wordpress Version' do |url|
        version = url.site_data_infos.last.cms_version
        if version == 'Version not found'
          div (url.site_data_infos.last.cms_version), :style => "color : red"
        else
          version
        end
      end
      row 'Themes' do |url|
        themes = url.site_data_infos.last.themes
        if JSON::parse(themes).size > 0
          link_to 'themes', admin_themes_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
        else
          div("Themes not found", style: "color: red")
        end
      end
      row 'Js' do |url|
        link_to 'js_info', admin_js_infos_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
      end
      row 'Cloudflare' do |url|
        cloudflare = url.site_data_infos.last.cloudflare
        if cloudflare == '0'
          div (SiteDataInfo::STATUS[cloudflare]),style: "color: red"
        elsif cloudflare =='1'
          div (SiteDataInfo::STATUS[cloudflare]),style: "color: green"
        end
      end
      row 'LastTest' do |url|
        link_to "Test #{url.site_data_infos.last.test_id}", admin_tests_path("q[id_equals]" => url.site_data_infos.last.test_id)
      end
    end
  end
end
