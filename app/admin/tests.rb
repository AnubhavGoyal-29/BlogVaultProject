ActiveAdmin.register Test do

  filter :status , :as => :select, :collection => Test::STATUS.invert

  index do
    column :id
    column :number_of_urls do |test|
      link_to 'urls', admin_urls_path()
    end
    column 'Status' do |test_status|
      div (Test::STATUS[test_status.status])
    end 
  end
end
