ActiveAdmin.register Theme do

  actions :index, :show  
  filter :theme_name
  filter :website_id
  filter :is_active, as: :select, collection: [["ACTIVE", true], ["INACTIVE", false]]
  filter :first_test
  filter :last_test
  filter :created_at
  filter :updated_at

  scope '', :default => true do |themes|
    themes.group(:theme_slug)
  end

  index do 
    id_column
    column :theme_name
    column "Usage" do |theme|
      args = Hash.new
      args[:theme_slug] = theme.theme_slug 
      if params["test_id"]
        args[:first_test] = -Float::INFINITY..params['test_id'].to_i
        args[:last_test] = params['test_id'].to_i..Float::INFINITY
      end
      website_ids = Theme.where(args).pluck(:website_id)
      link_to "#{website_ids.count} :: urls", admin_websites_path("q[id_in]" => website_ids)
    end
    column 'First Test' do |js|
      "Test #{js.first_test}"
    end
    column 'Last Test' do |js|
      "Test #{js.last_test}"
    end

    if params[:q]
      column 'Status' do |theme|
        status = theme.is_active ? "ACTIVE" : "INACTIVE"
        color = theme.is_active ? "green" : "red"
        div status, style: "color: #{color}"
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :theme_name
      row "Usage" do |theme|
        website_ids = Theme.where(:theme_name => theme.theme_name, :status => true).pluck(:website_id)
        link_to "#{website_ids.count} :: urls", admin_websites_path('q[id_in]' => website_ids)
      end
      row :first_test
      row :last_test
      if params[:q]
        row 'Status' do |theme|
          status = theme.is_active ? "ACTIVE" : "INACTIVE"
          color = theme.is_active ? "green" : "red"
          div status, style: "color: #{color}"
        end
      end
    end
  end

end
