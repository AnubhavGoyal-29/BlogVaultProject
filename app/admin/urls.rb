ActiveAdmin.register Url do
  actions :index, :show

  filter :id
  controller do 
    def scoped_collection
      Url.site_data_info
    end
  end
  index do
    column :id
    column :url
    column 'Plugins' do |url|
      link_to 'plugins', admin_plugins_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
    end
    column 'Themes' do |url|
      link_to 'themes', admin_themes_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
    end
    column 'Js' do |url|
      link_to 'js_info', admin_js_infos_path("q[url_id_equals]" => url.id, "q[status_equals]" => 1)
    end
    column 'Cloudflare' do |url|
      div (SiteDataInfo::STATUS[url.site_data_infos.last.cloudflare])
    end
    column 'LastTest' do |url|
      link_to "Test #{url.site_data_infos.last.test_id}", admin_tests_path("q[id_equals]" => url.site_data_infos.last.test_id)
    end

  end

  show do 
    attributes_table do
      row :url
      row 'Site Data Info' do |url|
        link_to url.site_data_infos.last, admin_site_data_info_path(url.site_data_info_id)
      end
    end
  end
end
