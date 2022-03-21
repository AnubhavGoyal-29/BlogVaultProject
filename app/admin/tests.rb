ActiveAdmin.register Test do

  actions :index, :show
  filter :status , :as => :select, :collection => Test::STATUS.invert
  filter :id
  filter :created_at
  filter :updated_at

  index do
    id_column
    column 'Wordpress Sites' do |test|
      website_ids = SiteDataInfo.where(test_id: test.id).pluck(:website_id)
      if website_ids.size > 0
        link_to "#{website_ids.count} urls", admin_websites_path('q[id_in]' => website_ids)
      else
        div ('no urls found')
      end
    end
    column 'Data Infos' do |test|
      website_ids = SiteDataInfo.where(test_id: 2).pluck(:website_id).to_s
      link_to 'data info', admin_site_data_infos_path("q[test_id_equals]" => test.id )
    end
    column 'Plugins' do |test|
      link_to 'plugins', admin_plugins_path('q[first_seen_less_than]' => test.id + 1, 
        'q[last_seen_greater_than]' => test.id - 1, :test_id => test.id)
    end
    column 'Themes' do |test|
      link_to 'themes', admin_themes_path('q[first_seen_less_than]' => test.id + 1, 
        'q[last_seen_greater_than]' => test.id - 1, :test_id => test.id)
    end
    column 'JS' do |test|
      link_to 'js', admin_js_infos_path('q[first_seen_less_than]' => test.id + 1, 
        'q[last_seen_greater_than]' => test.id - 1, :test_id => test.id)
    end
    column 'Status' do |test|
      status = test.status 
      case status
      when Test::Status::FAILED
        div ("FAILED"), style: "color : red"
      when Test::Status::INITIALIZED
        div ("INITIALIZED"), style: "color : orange"
      when Test::Status::COMPLETED
        div ("COMPLETED"),style: "color : green"
      else
        div ("RUNNING"), style: "color : blue"
      end
    end 
  end

  show do
    attributes_table do
      row :id
      row 'Urls' do |test|
        website_ids = SiteDataInfo.where(test_id: test.id).pluck(:website_id)
        if website_ids.size > 0
          link_to 'urls', admin_websites_path('q[id_in]' => website_ids)
        else
          div ('no urls found')
        end
      end
      row 'Data Infos' do |test|
        website_ids = SiteDataInfo.where(test_id: 2).pluck(:website_id).to_s
        link_to 'data info', admin_site_data_infos_path("q[test_id_equals]" => test.id )
      end
      row 'Status' do |test|
        status = test.status
        case status
        when Test::Status::FAILED
          div ("FAILED"), style: "color : red"
        when Test::Status::INITIALIZED
          div ("INITIALIZED"), style: "color : orange"
        when Test::Status::COMPLETED
          div ("COMPLETED"),style: "color : green"
        else
          div ("RUNNING"), style: "color : blue"
        end
      end
      row 'Plugins' do |test|
        link_to 'plugins', admin_plugins_path('q[first_seen_less_than]' => test.id + 1,
          'q[last_seen_greater_than]' => test.id - 1, :test_id => test.id)
      end
      row 'Themes' do |test|
        link_to 'themes', admin_themes_path('q[first_seen_less_than]' => test.id + 1,
          'q[last_seen_greater_than]' => test.id - 1, :test_id => test.id)
      end
      row 'JS' do |test|
        link_to 'js', admin_js_infos_path('q[first_seen_less_than]' => test.id + 1,
          'q[last_seen_greater_than]' => test.id - 1, :test_id => test.id)
      end
      row :created_at
    end
  end

end
