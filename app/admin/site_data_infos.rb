ActiveAdmin.register SiteDataInfo do

  actions :index, :show
  filter :test_id
  filter :website_id
  filter :cloudflare, as: :select, collection: [["ACTIVE", true], ["INACTIVE", false]]
  filter :id
  filter :created_at
  filter :updated_at

  scope :all, :default => true
  scope :Plugins_found, :default => true do |site_data_infos|
    site_data_infos.where.not(:plugin_ids => nil)    
  end
  scope :Themes_found, :default => true do |site_data_infos|
    site_data_infos.where.not(:theme_ids => nil)
  end
  scope :Js_found, :default => true do |site_data_infos|
    site_data_infos.where.not(:js_ids => nil)
  end
  scope :login_website_found, :default => true do |site_data_infos|
    site_data_infos.where.not(:login_url => '0')
  end
  scope :WP_version_found, :default => true do |site_data_infos|
    site_data_infos.where.not(:cms_version => nil)
  end

  index do 
    id_column
    column "Test" do |site_data|
      link_to site_data.test.id, admin_test_path(site_data.test)
    end
    column "website" do |site_data|
      link_to "#{site_data.website.id}:: #{site_data.website.url}", admin_website_path(site_data.website)
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
    column 'WP Version' do |site_data|
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

  show do
    attributes_table do
      row :id
      row 'website' do |site|
        link_to "#{site.website.id}:: #{site.website.url}", admin_website_path(site.website) 
      end
      row :test
      row :cms_type
      row 'Versions' do |site_data|
        link_to 'Versions', admin_site_data_infos_path('q[website_id_equals]' => site_data.website_id)
      end
      row 'Plugins' do |site_data|
        plugins = site_data.plugins
        if plugins.present?
          link_to 'Plugins', admin_plugins_path("q[website_id_equals]" => site_data.website_id)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'Themes' do |site_data|
        themes = site_data.themes
        if themes.present?
          link_to 'Themes', admin_themes_path("q[website_id_equals]" => site_data.website_id)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'JS' do |site_data|
        js = site_data.js
        if js.present?
          link_to 'JS', admin_js_infos_path('q[website_id_equals]' => site_data.website_id)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'WP Version' do |site_data|
        version = site_data.cms_version
        if version == nil
          div ('Not found'), :style => "color : red"
        else
          version
        end
      end
      row 'Cloudflare' do |site|
        status = site.cloudflare ? "ACTIVE" : "INACTIVE"
        color = site.cloudflare ? "green" : "red"
        div status, :style => "color : #{color}"
      end

      row 'Login website' do |site_data|
        if site_data.login_url == nil
          div ('Not found'), :style => "color : red"
        elsif site_data.login_url
          link_to site_data.login_url, "http://www.#{site_data.login_url}", :target => '_blank'
        end
      end
      row 'IP' do |site_data|
        link_to "#{ site_data.ip }", "#{site_data.ip}" , :target => 'blank'
      end
    end
  end

end
