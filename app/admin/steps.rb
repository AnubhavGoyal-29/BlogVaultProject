ActiveAdmin.register Step do

  actions :index
  filter :status , :as => :select, :collection => Step::STATUS.invert

  index do
    column :id
    column 'Status' do |step_status|
      div (Step::STATUS[step_status.status])
    end
    column :test_id
    column "Urls" do |step|
      link_to 'urls', admin_urls_path("q[id_equals]" => step.urls)
    end
  end

end
