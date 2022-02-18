ActiveAdmin.register Step do

  actions :index
  filter :status , :as => :select, :collection => Step::STATUS.invert

  index do
    column :id
    column 'Status' do |step_status|
      div (Step::STATUS[step_status.status])
    end
    column :total_urls
    column 'Test_Id' do |test|
      link_to "#{test.steps.test_id}", admin_tests_path(steps.id)
    end
  end

end
