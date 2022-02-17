ActiveAdmin.register SiteDataInfo do
  
  filter :id
  filter :test_id
  index do 
    column :id
    column "Test" do |site_data|
      link_to site_data.test.id, admin_test_path(site_data.test)
    end
    column "Url" do |site_data|
      link_to "#{site_data.url.id}:  #{site_data.url.url}", admin_url_path(site_data.url)
    end 
    column "Plugins" do |site|
      link_to 'plugins', admin_plugins_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
    end
    column "Js" do |site|
      link_to 'js', admin_js_infos_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
    end
    column "Themes" do |site|
      link_to 'themes', admin_themes_path("q[url_id_equals]" => site.url_id, "q[status_equals]" => 1)
    end
    column :cloudflare
  end
end
