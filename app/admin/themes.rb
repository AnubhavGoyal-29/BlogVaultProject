ActiveAdmin.register Theme do

  actions :index, :show  
  filter :theme_name
  filter :url_id
  filter :status , :as => :select, :collection => Theme::STATUS.invert

  index do 
    id_column
    column 'Name' do|theme|
      name = ( ThemeSlug.where("name LIKE?","%#{theme.theme_name}%").first && ThemeSlug.where("slug LIKE?" , "%#{theme.theme_name}%").first.name )
      name ||= theme.theme_name
      div ( name )
    end
=begin
    column 'Theme Name' do |theme|
      link_to theme.theme_name, "https://www.wordpress.org/themes/#{theme.theme_name}", :target => 'blank'
    end
=end
    column "Usage" do |theme|
      if !params["test_id"]
        url_ids = Theme.where(:theme_name => theme.theme_name, :status => Theme::STATUS.invert[:ACTIVE]).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      else
        url_ids = Theme.where("first_seen <= ?", params["test_id"]).where("last_seen >= ?", params["test_id"]).where(:theme_name => theme.theme_name).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      end
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
