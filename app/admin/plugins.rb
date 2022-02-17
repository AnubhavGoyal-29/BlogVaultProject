ActiveAdmin.register Plugin do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :plugin_name, :url_id, :status, :type, :version, :other_data
  #
  # or
  #
  # permit_params do
  #   permitted = [:plugin_name, :url_id, :status, :type, :version, :other_data]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
 filter :url_id 
 filter :status
 index do 
   column :plugin_name
   column 'Url' do |plugin|
     link_to "#{plugin.url.id} ::  #{plugin.url.url}", admin_url_path(plugin.url)
   end
 end
end
