ActiveAdmin.register Theme do

  actions :index  
  filter :theme_name
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
      options = Theme::STATUS.invert
      if status == options[:FAILED]
        div ("FAILED"),style: "color: red"
      elsif status == options[:INITIALIZED]
        div ("INITIALIZED"),style: "color: orange"
      elsif status == options[:COMPLETED]
        div ("COMPLETED"),style: "color: green"
      else
        div ("RUNNING"),style: "color: blue"
      end
    end
  end

end
