ActiveAdmin.register Theme do

  actions :index, :show  
  filter :theme_name
  filter :url_id
  filter :first_seen
  filter :last_seen
  filter :created_at
  filter :updated_at
  filter :status , :as => :select, :collection => Theme::STATUS.invert

  index do 
    id_column
    column 'Name' do|theme|
      name = ( ThemeSlug.where("name LIKE?","#{theme.theme_name}").first &&
              ThemeSlug.where("slug LIKE?" , "#{theme.theme_name}").first.name )
      name ||= theme.theme_name
      div ( name )
    end
    column "Usage" do |theme|
      if !params["test_id"]
        url_ids = Theme.where(:theme_name => theme.theme_name, :status => Theme::Status::ACTIVE).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      else
        url_ids = Theme.where("first_seen <= ?", params["test_id"]).
          where("last_seen >= ?", params["test_id"]).where(:theme_name => theme.theme_name).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      end
    end
    column :first_seen
    column :last_seen
    if params[:q]
      column 'Status' do |theme|
        status = theme.status
        if status == Theme::Status::INACTIVE
          div (Theme::STATUS[status]),style: "color: red"
        elsif status == Theme::Status::ACTIVE
          div (Theme::STATUS[status]),style: "color: green"
        end
      end
    end
  end

  show do
    attributes_table do
      row :id
      row 'Name' do|theme|
        name = ( ThemeSlug.where("name LIKE?","#{theme.theme_name}").first &&
                ThemeSlug.where("slug LIKE?" , "#{theme.theme_name}").first.name )
        name ||= theme.theme_name
        div ( name )
      end
      row "Usage" do |theme|
        if !params["test_id"]
          url_ids = Theme.where(:theme_name => theme.theme_name, :status => Theme::Status::ACTIVE).pluck(:url_id)
          link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
        else
          url_ids = Theme.where("first_seen <= ?", params["test_id"]).
            where("last_seen >= ?", params["test_id"]).where(:theme_name => theme.theme_name).pluck(:url_id)
          link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
        end
      end
      row :first_seen
      row :last_seen
      if params[:q]
        row 'Status' do |theme|
          status = theme.status
          if status == Theme::Status::INACTIVE
            div (Theme::STATUS[status]),style: "color: red"
          elsif status == Theme::Status::ACTIVE
            div (Theme::STATUS[status]),style: "color: green"
          end
        end
      end
    end
  end

end
