ActiveAdmin.register_page "Tests" do

  sidebar :filters do
    render partial: 'filter'
  end

  content do
    args = {}
    if params["sidebar_filters"]
      args[:id] = params["sidebar_filters"]["test_id"] if params["sidebar_filters"]["test_id"].present?
      args[:status] = params["sidebar_filters"]["status"] if params["sidebar_filters"]["status"].present?
      created_from = params["sidebar_filters"]["created_from"].present? ? params["sidebar_filters"]["created_from"] : Test.first.created_at
      created_to = params["sidebar_filters"]["created_to"].present? ? params["sidebar_filters"]["created_to"] : Time.now
      args[:created_at] = created_from..created_to

      updated_from = params["sidebar_filters"]["updated_from"].present? ? params["sidebar_filters"]["updated_from"] : Test.first.created_at
      updated_to = params["sidebar_filters"]["updated_to"].present? ? params["sidebar_filters"]["updated_to"] : Time.now
      args[:updated_at] = updated_from..updated_to
    end

    panel "Tests" do
      table_for Test.where(args) do
        column :id
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
        column :created_at
        column :updated_at
      end
    end
  end
end

