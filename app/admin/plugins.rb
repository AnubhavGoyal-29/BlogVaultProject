ActiveAdmin.register Plugin do

  actions :index, :show  
  filter :plugin_name
  filter :website_id
  filter :is_active, as: :select, collection: [["ACTIVE", true], ["INACTIVE", false]]
  filter :first_test
  filter :last_test
  filter :created_at
  filter :updated_at
  
  scope '', :default => true do |plugins|
    plugins.group(:plugin_slug)
  end

  index do 
    id_column
    column :plugin_name
    column "Usage" do |plugin|
      args = Hash.new
      args[:plugin_slug] = plugin.plugin_slug
      if params["test_id"]
        args[:first_test] = -Float::INFINITY..params['test_id'].to_i
        args[:last_test] = params['test_id'].to_i..Float::INFINITY
      end
      website_ids = Plugin.where(args).pluck(:website_id)
      link_to "#{website_ids.count} :: urls", admin_websites_path("q[id_in]" => website_ids)
    end
    column 'First Test' do |plugin|
      "Test #{plugin.first_test}"
    end
    column 'Last Test' do |plugin|
      "Test #{plugin.last_test}"
    end

    if params[:q]
      column 'Status' do |plugin|
        status = plugin.is_active ? "ACTIVE" : "INACTIVE"
        color = plugin.is_active ? "green" : "red"
        div status, style: "color: #{color}"
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :plugin_name
      row "Usage" do |plugin|
        website_ids = Plugin.where(:plugin_name => plugin.plugin_name, :is_active => true).pluck(:website_id)
        link_to "#{website_ids.count} :: urls", admin_websites_path('q[id_in]' => website_ids)
      end
      row :first_test
      row :last_test
      if params[:q]
        row 'Status' do |plugin|
          status = plugin.is_active ? "ACTIVE" : "INACTIVE"
          color = plugin.is_active ? "green" : "red"
          div status, style: "color: #{color}"
        end
      end
    end
  end
end

