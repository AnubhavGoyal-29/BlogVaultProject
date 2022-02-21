ActiveAdmin.register Url do

  actions :index, :show
   index do 
    column :id
    column :url
    column :site_data_info
   end

end
