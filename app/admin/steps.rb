ActiveAdmin.register Step do

  actions :index
  filter :status , :as => :select, :collection => Step::STATUS.invert

  index do
    column :id
    column :test_id
    column "Urls" do |step|
      link_to 'urls', admin_urls_path()
    end
    column 'Status' do |step|
      step = step.status
      if step == '0'
      div (Step::STATUS[step]), style: "color: blue"
      elsif step == '1'
      div (Step::STATUS[step]), style: "color: orange"
      elsif step == '2'
      div (Step::STATUS[step]), style: "color: green"
      elsif step == '3'
      div (Step::STATUS[step]), style: "color: red"
      end
    end
  end

end
