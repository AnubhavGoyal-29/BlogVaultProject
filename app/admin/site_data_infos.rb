ActiveAdmin.register SiteDataInfo do

  actions :index, :show
  filter :test_id
  filter :url_id
  filter :cloudflare, :as => :select, :collection => SiteDataInfo::CLOUDFLARESTATUS.invert
  filter :id

  scope :all, :default => true
  scope :Plugins_found, :default => true do |site_data_infos|
    site_data_infos.where.not(:plugins => '[]')    
  end
  scope :Themes_found, :default => true do |site_data_infos|
    site_data_infos.where.not(:themes => '[]')
  end
  scope :Js_found, :default => true do |site_data_infos|
    site_data_infos.where.not(:js => '[]')
  end
  scope :login_url_found, :default => true do |site_data_infos|
    site_data_infos.where.not(:login_url => '0')
  end
  scope :WP_version_found, :default => true do |site_data_infos|
    site_data_infos.where.not(:cms_version => 'version not found')
  end

  index do 
    id_column
    column "Test" do |site_data|
      link_to site_data.test.id, admin_test_path(site_data.test)
    end
    column "Url" do |site_data|
      link_to "#{site_data.url.id}:: #{site_data.url.url}", admin_url_path(site_data.url)
    end 
    column 'Plugins' do |site_data|
      plugins = site_data.plugins
      if JSON::parse(plugins).size > 0
        link_to 'Plugins', admin_plugins_path("q[url_id_equals]" => site_data.url_id)
      else
        div("Not found", style: "color: red")
      end
    end
    column 'Themes' do |site_data|
      themes = site_data.themes
      if JSON::parse(themes).size > 0
        link_to 'Themes', admin_themes_path("q[url_id_equals]" => site_data.url_id)
      else
        div("Not found", style: "color: red")
      end
    end
    column 'JS' do |site_data|
      js = site_data.js
      if JSON::parse(js).size > 0
        link_to 'JS', admin_js_infos_path('q[url_id_equals]' => site_data.url_id)
      else
        div("Not found", style: "color: red")
      end
    end
    column 'WP Version' do |site_data|
      version = site_data.cms_version
      if version == 'version not found'
        div ('Not found'), :style => "color : red"
      else
        version
      end
    end
    column 'Cloudflare' do |site|
      if site.cloudflare == SiteDataInfo::CloudFlareStatus::INACTIVE
        div (SiteDataInfo::CLOUDFLARESTATUS[site.cloudflare]),style: "color: red"
      elsif site.cloudflare == SiteDataInfo::CloudFlareStatus::ACTIVE
        div (SiteDataInfo::CLOUDFLARESTATUS[site.cloudflare]),style: "color: green"
      end
    end
    column 'Login Url' do |site_data|
      if site_data.login_url == SiteDataInfo::LoginUrl::NOTFOUND
        div ('Not found'), :style => "color : red"
      else
        link_to site_data.login_url, "http://www.#{site_data.login_url}", :target => '_blank'
      end
    end
    column 'IP' do |site_data|
      link_to "#{ site_data.ip }", "http://#{site_data.ip}" , :target => 'blank'
    end
  end

  show do
    attributes_table do
      row :id
      row 'url' do |site|
        link_to "#{site.url.id}:: #{site.url.url}", admin_url_path(site.url) 
      end
      row :test
      row :cms_type
      row 'Versions' do |site_data|
        link_to 'Versions', admin_site_data_infos_path('q[url_id_equals]' => site_data.url_id)
      end
      row 'Plugins' do |site_data|
        plugins = site_data.plugins
        if JSON::parse(plugins).size > 0
          link_to 'Plugins', admin_plugins_path("q[url_id_equals]" => site_data.url_id)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'Themes' do |site_data|
        themes = site_data.themes
        if JSON::parse(themes).size > 0
          link_to 'Themes', admin_themes_path("q[url_id_equals]" => site_data.url_id)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'JS' do |site_data|
        js = site_data.js
        if JSON::parse(js).size > 0
          link_to 'JS', admin_js_infos_path('q[url_id_equals]' => site_data.url_id)
        else
          div("Not found", style: "color: red")
        end
      end
      row 'WP Version' do |site_data|
        version = site_data.cms_version
        if version == 'version not found'
          div ('Not found'), :style => "color : red"
        else
          version
        end
      end
      row 'Cloudflare' do |site|
        if site.cloudflare == SiteDataInfo::CloudFlareStatus::INACTIVE
          div (SiteDataInfo::CLOUDFLARESTATUS[site.cloudflare]),style: "color: red"
        elsif site.cloudflare == SiteDataInfo::CloudFlareStatus::ACTIVE
          div (SiteDataInfo::CLOUDFLARESTATUS[site.cloudflare]),style: "color: green"
        end
      end
      row 'Login Url' do |site_data|
        if site_data.login_url == SiteDataInfo::LoginUrl::NOTFOUND
          div ('Not found'), :style => "color : red"
        elsif site_data.login_url
          link_to site_data.login_url, "http://www.#{site_data.login_url}", :target => '_blank'
        end
      end
      row 'IP' do |site_data|
      link_to "#{ site_data.ip }", "http://#{site_data.ip}" , :target => 'blank'
    end
    end
  end

end
