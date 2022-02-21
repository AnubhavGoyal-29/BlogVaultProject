ActiveAdmin.register Step do

  actions :index
  filter :status , :as => :select, :collection => Step::STATUS.invert

  index do
    column :id
    column 'Status' do |step_status|
      if step_status.status == '0' 
       div (Step::STATUS[step_status.status]), :style => "color : yellow"
      elsif step_status.status == '1'
       div (Step::STATUS[step_status.status]), :style => "color : blue" 
      elsif step_status.status == '2'
       div (Step::STATUS[step_status.status]), :style => "color : green"
      else 
       div (Step::STATUS[step_status.status]), :style => "color : red"
      end
    end
    column :test_id
    column "Urls" do |step|
      link_to 'urls', admin_urls_path("q[id_equals]" => step.urls)
    end
  end

end
