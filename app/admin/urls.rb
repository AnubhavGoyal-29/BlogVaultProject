ActiveAdmin.register Url do

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
        link_to "#{url.site_data_infos.last}", admin_site_data_infos_path("q[id_equals]" => url.site_data_infos.last.id)
      else 
        'not a wordpress site'
      end
    end
  end
end
