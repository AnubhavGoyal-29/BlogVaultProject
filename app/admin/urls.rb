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
    column "SiteDataInfo" do |url|
      if url.site_data_info_id
        link_to "#{url.site_data_infos.last}", admin_site_data_info_path(url.site_data_info_id)
      else 
        'not a wordpress site'
      end
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
