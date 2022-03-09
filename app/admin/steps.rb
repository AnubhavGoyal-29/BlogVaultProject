ActiveAdmin.register Step do

  actions :index
  filter :status , :as => :select, :collection => Step::STATUS.invert
  filter :test_id
  filter :id
  filter :created_at
  filter :updated_at

  index do
    id_column
    column :test_id
    column "Urls" do |step|
      url_ids = JSON.parse(step.urls)
      link_to 'urls', admin_urls_path('q[id_in]' => url_ids)
    end
    column 'Status' do |step|
      status = step.status
      case status
      when Step::Status::FAILED
        div ("FAILED"), style: "color : red"
      when Step::Status::INITIALIZED
        div ("INITIALIZED"), style: "color : orange"
      when Step::Status::SUCCEED
        div ("COMPLETED"),style: "color : green"
      else
        div ("RUNNING"), style: "color : blue"
      end
    end
  end

end
