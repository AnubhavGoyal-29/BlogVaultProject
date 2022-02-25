ActiveAdmin.register Theme do

  actions :index, :show  
  filter :theme_name
  filter :url_id
  filter :status , :as => :select, :collection => Theme::STATUS.invert

  index do 
    id_column
    column :theme_name
    column 'Used IN' do |theme|
      link_to "#{theme.url.id} ::  #{theme.url.url}", admin_url_path(theme.url)
    end
    column 'Status' do |theme|
      status = theme.status
      options = Theme::STATUS.invert
      if status == options[:INACTIVE]
        div (Theme::STATUS[status]),style: "color: red"
      elsif status == options[:ACTIVE]
        div (Theme::STATUS[status]),style: "color: green"
      end
    end
  end

  show do
    attributes_table do
      row :theme_name
      row "Usage" do |theme|
        url_ids = Theme.where(:theme_name => theme.theme_name, :status => Theme::STATUS.invert[:ACTIVE]).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      end
    end
  end

end
