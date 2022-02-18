ActiveAdmin.register Url do

  actions :index, :show
   index do 
    column :id
    column :url
    column :site_data_info
   end

  filter :id
  controller do 
    def scoper_collection
      Url.site_data_info
    end
  end
  index do 
    column :id
    column :url
    column "SiteDataInfo" do |url|
      if url.site_data_infos.last
        link_to "#{url.site_data_infos.last}", admin_site_data_infos_path("q[id_equals]" => url.site_data_infos.last.id)
      end
    end
  end
end
