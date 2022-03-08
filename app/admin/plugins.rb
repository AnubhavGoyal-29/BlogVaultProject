ActiveAdmin.register Plugin do

  actions :index, :show  
  filter :plugin_name
  filter :url_id
  filter :status 
  filter :first_seen
  filter :last_seen
  filter :created_at
  filter :updated_at

  index do 
    id_column
    column :plugin_name
    column "Usage" do |plugin|
      args = Hash.new
      args[:plugin_slug] = plugin.plugin_slug
      if params["test_id"]
        args[:first_seen] = -Float::INFINITY..params['test_id'].to_i
        args[:last_seen] = params['test_id'].to_i..Float::INFINITY
      end
      url_ids = Plugin.where(args).pluck(:url_id)
      link_to "#{url_ids.count} :: urls", admin_urls_path("q[id_in]" => url_ids)
    end
    column :first_seen
    column :last_seen
    if params[:q]
      column 'Status' do |plugin|
        status = plugin.status
        if status == false
          div ("INACTIVE"), style: "color: red"
        else
          div ("ACTIVE"), style: "color: green"
        end
      end
    end
  end

  show do
    attributes_table do
      row :id
      row 'Name' do|plugin|
        slug_name = PluginSlug.where("slug LIKE?", "#{ plugin.plugin_name }").first
        name = slug_name && slug_name.name
        name ||= plugin.plugin_name
        div (name)
      end
      row "Usage" do |plugin|
        if !params["test_id"]
          url_ids = Plugin.where(:plugin_name => plugin.plugin_name, :status => true).pluck(:url_id)
          link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
        else
          url_ids = Plugin.where("first_seen <= ?", params["test_id"]).
            where("last_seen >= ?", params["test_id"]).
            where(:plugin_name => plugin.plugin_name).pluck(:url_id)
          link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
        end
      end
      row :first_seen
      row :last_seen
      if params[:q]
        row 'Status' do |plugin|
          status = plugin.status
          if status == false
            div ("INACTIVE"), style: "color: red"
          else
            div ("ACTIVE"), style: "color: green"
          end
        end
      end
    end
  end
end

