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
    column :url
    column 'Versions' do |url|
      link_to 'versions', admin_site_data_infos_path('q[url_id_equals]' => url.id)
    end
    column 'LastTest' do |url|
      link_to "Test #{url.site_data_infos.last.test_id}", admin_tests_path("q[id_equals]" => url.site_data_infos.last.test_id)
    end
    column 'LastTestData' do |url|
      link_to "LastTestdata", admin_site_data_infos_path("q[url_id_equals]" => url.site_data_infos.last.url_id, "q[test_id_equals]" => url.site_data_infos.last.test_id)
    end
  end

  show do 
    attributes_table do
      row :url
      row 'Last Test Data' do |url|
        link_to "Test Data Info", admin_site_data_info_path(url.site_data_info_id)
      end
      row 'Versions' do |url|
        link_to 'versions', admin_site_data_infos_path('q[url_id_equals]' => url.id)
      end
      row 'LastTest' do |url|
        link_to "Test #{url.site_data_infos.last.test_id}", admin_tests_path("q[id_equals]" => url.site_data_infos.last.test_id)
      end

    end
  end
end
