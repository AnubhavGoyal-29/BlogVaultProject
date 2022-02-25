ActiveAdmin.register Test do

  actions :index, :show
  filter :status , :as => :select, :collection => Test::STATUS.invert

  index do
    id_column
    column 'Data Infos' do |test|
      url_ids = SiteDataInfo.where(test_id: 2).pluck(:url_id).to_s
      link_to 'data info', admin_site_data_infos_path("q[test_id_equals]" => test.id )
    end
    column 'Plugins' do |test|
      plugin_ids = []
      SiteDataInfo.where(:test_id => test.id).each do |site_data|
        JSON.parse(site_data.plugins).each do |plugin_id|
          plugin_ids << plugin_id
        end
      end
      plugin_ids.uniq!
      link_to 'plugins', admin_plugins_path('q[id_in]' => plugin_ids)
    end
    column 'Themes' do |test|
      theme_ids = []
      SiteDataInfo.where(:test_id => test.id).each do |site_data|
        JSON.parse(site_data.themes).each do |theme_id|
          theme_ids << theme_id
        end
      end
      theme_ids.uniq!
      link_to 'themes', admin_themes_path('q[id_in]' => theme_ids)
    end
    column 'JS' do |test|
      js_ids = []
      SiteDataInfo.where(:test_id => test.id).each do |site_data|
        JSON.parse(site_data.js).each do |js_id|
          js_ids << js_id
        end
      end
      js_ids.uniq!
      link_to 'JS', admin_js_infos_path('q[id_in]' => js_ids)
    end
    column 'Status' do |test|
      status = test.status 
      options = Test::STATUS.invert
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

  show do
    attributes_table do
      row :id
      row 'Data Infos' do |test|
        url_ids = SiteDataInfo.where(test_id: 2).pluck(:url_id).to_s
        link_to 'data info', admin_site_data_infos_path("q[test_id_equals]" => test.id )
      end
      row 'Status' do |test|
        status = test.status
        options = Test::STATUS.invert
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
      row :created_at

    end
  end

end
