ActiveAdmin.register Url do
  actions :all, except: [:update, :destroy]
  permit_params :url
  form do |f|
    f.inputs 'Details' do
      f.input :url
    end
    end
  preserve_default_filters!
  filter :plugin
  index do
    selectable_column
    column :id
    column "Url" do |url|
      link_to url.url,'./'+url.url
    end
    column :test_id
  end

end
