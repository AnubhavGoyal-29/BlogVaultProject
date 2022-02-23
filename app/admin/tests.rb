ActiveAdmin.register Test do

  actions :index, :show
  filter :status , :as => :select, :collection => Test::STATUS.invert

  index do
    id_column
    column 'Data Infos' do |test|
      url_ids = SiteDataInfo.where(test_id: 2).pluck(:url_id).to_s
      link_to 'data info', admin_site_data_infos_path("q[test_id_equals]" => test.id )
    end
    column 'Steps' do |test|
      link_to 'steps', admin_steps_path('q[test_id_equals]' => test.id)
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
