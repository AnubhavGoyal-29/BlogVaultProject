ActiveAdmin.register Theme do

  actions :index  
  filter :theme_name
  filter :url_id
  filter :status , :as => :select, :collection => Theme::STATUS.invert

  index do 
    column :id
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

end
