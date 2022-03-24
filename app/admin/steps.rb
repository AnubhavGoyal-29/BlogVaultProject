ActiveAdmin.register_page "Steps" do
  
  sidebar :filters do
    render partial: 'filter'
  end

  content do
    args = {}
    if params["sidebar_filters"]
    args[:test_id] = params["sidebar_filters"]["test_id"] if params["sidebar_filters"]["test_id"].present?
    args[:id] = params["sidebar_filters"]["step_id"] if params["sidebar_filters"]["step_id"].present?
    args[:status] = params["sidebar_filters"]["status"] if params["sidebar_filters"]["status"].present?
    end
    n = 0
    color_class = ['active_admin_table_css_dark','active_admin_table_css_light']
    table_for Step.where(args) do
      column :id, :class => color_class[0]
      column :test_id, :class => color_class[1]
      column "Urls" do |step|
        website_ids = JSON.parse(step.urls)
       div (link_to 'urls', admin_websites_path('q[id_in]' => website_ids)), :class => color_class[step.id.to_i % 2]
      end
      column 'Status' do |step|
        status = step.status
        case status
        when Step::Status::FAILED
          div ("FAILED"), style: "color : red", :class => color_class[step.id % 2]
        when Step::Status::INITIALIZED
          div ("INITIALIZED"), style: "color : orange", :class => color_class[step.id % 2]
        when Step::Status::SUCCEED
          div ("SUCCEED"),style: "color : green", :class => color_class[step.id % 2]
        else
          div ("RUNNING"), style: "color : blue", :class => color_class[step.id % 2]
        end
      end
    end
  end

end
