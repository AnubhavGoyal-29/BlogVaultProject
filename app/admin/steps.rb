ActiveAdmin.register_page "Steps" do
  
  sidebar :filters do
    render partial: 'filter'
  end
  content do
    args = {}
    puts params
    if params["sidebar_filters"]
    args[:test_id] = params["sidebar_filters"]["test_id"] if params["sidebar_filters"]["test_id"].present?
    args[:id] = params["sidebar_filters"]["step_id"] if params["sidebar_filters"]["step_id"].present?
    args[:status] = params["sidebar_filters"]["status"] if params["sidebar_filters"]["status"].present?

    created_from = params["sidebar_filters"]["created_from"].present? ? params["sidebar_filters"]["created_from"] : Test.first.created_at
    created_to = params["sidebar_filters"]["created_to"].present? ? params["sidebar_filters"]["created_to"] : Time.now
    args[:created_at] = created_from..created_to

    updated_from = params["sidebar_filters"]["updated_from"].present? ? params["sidebar_filters"]["updated_from"] : Test.first.created_at
    updated_to = params["sidebar_filters"]["updated_to"].present? ? params["sidebar_filters"]["updated_to"] : Time.now
    args[:updated_at] = updated_from..updated_to
    end
    puts args
    table_for Step.where(args) do
      column :id
      column :test_id
      column "Urls" do |step|
        website_ids = JSON.parse(step.urls)
        link_to 'urls', admin_websites_path('q[id_in]' => website_ids)
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

end
