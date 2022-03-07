ActiveAdmin.register Plugin do

  actions :index, :show  
  filter :plugin_name
  filter :url_id
  filter :status , :as => :select, :collection => Plugin::STATUS.invert
  filter :first_seen
  filter :last_seen

  index do 
    id_column
    column 'Name' do|plugin|
      name = (PluginSlug.where("slug LIKE?", "#{ plugin.plugin_name }").first && 
              PluginSlug.where("slug LIKE?", "#{ plugin.plugin_name }").first.name) 
      name ||= plugin.plugin_name
      div (name)
    end
=begin
    column 'Plugin Name' do |plugin|
      link_to plugin.plugin_name, "https://www.wordpress.org/plugins/#{plugin.plugin_name}", :target => 'blank'
    end
=end
    column "Usage" do |plugin|
      if !params["test_id"]
        url_ids = Plugin.where(:plugin_name => plugin.plugin_name, :status => Plugin::Status::ACTIVE).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      else
        url_ids = Plugin.where("first_seen <= ?", params["test_id"]).
          where("last_seen >= ?",params["test_id"]).
          where(:plugin_name => plugin.plugin_name).pluck(:url_id)
        link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
      end
    end
    column :first_seen
    column :last_seen
    if params[:q]
      column 'Status' do |plugin|
        status = plugin.status
        if status == Plugin::Status::INACTIVE
          div (Plugin::STATUS[status]),style: "color: red"
        elsif status == Plugin::Status::ACTIVE
          div (Plugin::STATUS[status]),style: "color: green"
        end
      end
    end
  end

  show do
    attributes_table do
      row :id
      row 'Name' do|plugin|
        name = (PluginSlug.where("slug LIKE?", "#{ plugin.plugin_name }").first &&
                PluginSlug.where("slug LIKE?", "#{ plugin.plugin_name }").first.name)
        name ||= plugin.plugin_name
        div (name)
      end
      row "Usage" do |plugin|
        if !params["test_id"]
          url_ids = Plugin.where(:plugin_name => plugin.plugin_name, :status => Plugin::Status::ACTIVE).pluck(:url_id)
          link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
        else
          url_ids = Plugin.where("first_seen <= ?", params["test_id"]).
            where("last_seen >= ?",params["test_id"]).
            where(:plugin_name => plugin.plugin_name).pluck(:url_id)
          link_to "#{url_ids.count} :: urls", admin_urls_path('q[id_in]' => url_ids)
        end
      end
      row :first_seen
      row :last_seen
      if params[:q]
        row 'Status' do |plugin|
          status = plugin.status
          if status == Plugin::Status::INACTIVE
            div (Plugin::STATUS[status]),style: "color: red"
          elsif status == Plugin::Status::ACTIVE
            div (Plugin::STATUS[status]),style: "color: green"
          end
        end
      end
    end
  end
end

