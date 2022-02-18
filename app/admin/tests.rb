ActiveAdmin.register Test do

  filter :status , :as => :select, :collection => Test::STATUS.invert

  index do
    column :id
    column :number_of_urls
    column 'Status' do |test_status|
      div (Test::STATUS[test_status.status])
    end 
  end
end
