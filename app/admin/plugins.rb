ActiveAdmin.register Plugin do
    
    actions :index  

    filter :status , :as => :select, :collection => Plugin::STATUS.invert
    
    index do 
      column :id
      column :Url
      column :Status
      column :version
    end
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
  
end
