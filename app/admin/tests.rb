ActiveAdmin.register Test do

  filter :status , :as => :select, :collection => Test::STATUS.invert

  index do
    column :id

    column 'Test Info' do |test|
      url_ids = SiteDataInfo.where(test_id: 2).pluck(:url_id).to_s
      link_to 'urls', admin_site_data_infos_path("q[test_id_equals]" => test.id )
    end

    column 'Status' do |test|
      if test.status == '0'
        div (Test::STATUS[test.status]), :style => "color : yellow"
      elsif test.status == '1'
        div (Test::STATUS[test.status]), :style => "color : green"
      else 
        div (Test::STATUS[test.status]), :style => "color : red"
      end
    end 

  end
end
