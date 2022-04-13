ActiveAdmin.register_page "Site_Data_Infos" do

  sidebar :filters do
    render partial: 'filter'
  end


  content do
    args = {} 
    if params["q"] and params["q"]["test_id_equals"].present?
      args[:test_id] = params["q"]["test_id_equals"]
    end
    panel "Test Data Info"do
    table_for V2::SiteDataInfo.where(args) do
    column :id
    column "Test" do |site_data|
      link_to site_data.test.id, admin_tests_path(site_data.test)
    end
    column "website" do |site_data|
      link_to "#{site_data.website.id}:: #{site_data.website.url}", admin_websites_path(site_data.website)
    end 
    column 'Plugins' do |site_data|
      plugins = site_data.plugin_ids
      if plugins.present?
        link_to 'Plugins', admin_plugins_path("q[website_id_equals]" => site_data.website_id)
      else
        div("Not found", style: "color: red")
      end
    end
    column 'Themes' do |site_data|
      themes = site_data.theme_ids
      if themes.present?
        link_to 'Themes', admin_themes_path("q[website_id_equals]" => site_data.website_id)
      else
        div("Not found", style: "color: red")
      end
    end
    column 'JS' do |site_data|
      js = site_data.js_ids
      if js.present?
        link_to 'JS', admin_js_infos_path('q[website_id_equals]' => site_data.website_id)
      else
        div("Not found", style: "color: red")
      end
    end
    column :cms_type
    column 'Cms Version' do |site_data|
      version = site_data.cms_version
      if version == nil
        div ('Not found'), :style => "color : red"
      else
        version
      end
    end
    column 'Cloudflare' do |site|
      status = site.cloudflare ? "ACTIVE" : "INACTIVE"
      color = site.cloudflare ? "green" : "red"
      div status, :style => "color : #{color}"
    end
    column ' Login Url' do |site_data|
      if site_data.login_url == nil
        div ('Not found'), :style => "color : red"
      else
        link_to site_data.login_url, "http://www.#{site_data.login_url}", :target => '_blank'
      end
    end
    column :ip
  end
    end
  end
end
