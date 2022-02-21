ActiveAdmin.register Test do

  filter :status , :as => :select, :collection => Test::STATUS.invert

  index do
    column :id

    column 'Test Info' do |test|
      url_ids = SiteDataInfo.where(test_id: 2).pluck(:url_id).to_s
      link_to 'urls', admin_urls_path("q[id_equals]" => url_ids)
    end

    column 'Status' do |test_status|
      div (Test::STATUS[test_status.status])
    end 

  end
end
