ActiveAdmin.register Step do

  actions :index
  filter :status , :as => :select, :collection => Step::STATUS.invert
  filter :test_id
  index do
    column :id
    column :test_id
    column "Urls" do |step|
      url_ids = JSON.parse(step.urls)
      link_to 'urls', admin_urls_path('q[id_in]' => url_ids)
    end
    column 'Status' do |step|
      status = step.status
      options = Step::STATUS.invert
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

end
