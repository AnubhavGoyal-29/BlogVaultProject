ActiveAdmin.register Theme do

  actions :index, :show  
  filter :theme_name
  filter :url_id
  filter :first_seen
  filter :last_seen
  filter :created_at
  filter :updated_at
  filter :status 

  index do 
    id_column
    column :theme_name
    column "Usage" do |theme|
      args = Hash.new
      args[:theme_slug] = theme.theme_slug 
      if params["test_id"]
        args[:first_seen] = -Float::INFINITY..params['test_id'].to_i
        args[:last_seen] = params['test_id'].to_i..Float::INFINITY
      end
      url_ids = Theme.where(args).pluck(:url_id)
      link_to "#{url_ids.count} :: urls", admin_urls_path("q[id_in]" => url_ids)
    end
    column :first_seen
    column :last_seen
    if params[:q]
      column 'Status' do |theme|
        status = theme.status
        if status == false
          div ("INACTIVE"),style: "color: red"
        else
          div ("ACTIVE"),style: "color: green"
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
        url_ids = Theme.where(:theme_name => theme.theme_name, :status => true).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      end
      row :first_seen
      row :last_seen
      if params[:q]
        row 'Status' do |theme|
          status = theme.status
          if status == false
            div ("INACTIVE"),style: "color: red"
          else
            div ("ACTIVE"),style: "color: green"
          end
        end
      end
    end
  end

end
