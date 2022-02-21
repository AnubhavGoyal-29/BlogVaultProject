ActiveAdmin.register Theme do

  actions :index  

  filter :url_id
  filter :status , :as => :select, :collection => Theme::STATUS.invert

  index do 
    column :id
    column :theme_name
    column 'Url' do |theme|
      link_to "#{theme.url.id} ::  #{theme.url.url}", admin_url_path(theme.url)
    end
    column 'Status' do |theme|
      status = theme.status
      if status == '0'
        div (Theme::STATUS[status]),style: "color: red"
      elsif status =='1'
        div (Theme::STATUS[status]),style: "color: green"
      end
    end
  end

end
