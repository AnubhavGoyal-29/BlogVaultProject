ActiveAdmin.register SiteData do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :cms_type, :cms_version, :js, :cloudflare, :login_url, :hosting, :plugin_id, :theme_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:cms_type, :cms_version, :js, :cloudflare, :login_url, :hosting, :plugin_id, :theme_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
