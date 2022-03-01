ActiveAdmin.register_page "Compare" do


  page_action :test_method, :method => [:get, :post] do
    if params[:_method] == "get"
      flash[:notice] = params
      #redirect_to admin_compare_path
      render :partial => "form", :locals => { :id => params[:url_id] }
    else
      test_id_1 = params[:test_method][:test1]
      test_id_2 = params[:test_method][:test2]
      url_id = params[:test_method][:url_id]
      data_1 = SiteDataInfo.where(:test_id => test_id_1, :url_id => url_id).first
      data_2 = SiteDataInfo.where(:test_id => test_id_2, :url_id => url_id).first

      plugin_1 = JSON.parse( data_1.plugins )
      plugin_2 = JSON.parse( data_2.plugins )
      plugins_common = plugin_1 & plugin_2

      for i in 0..( plugin_1.size - 1 )
        plugin_1[i] = Plugin.find(plugin_1[i]).plugin_name
      end
      for i in 0..( plugin_2.size - 1 )
        plugin_2[i] = Plugin.find(plugin_2[i]).plugin_name
      end
      for i in 0..( plugins_common.size - 1 )
        plugins_common[i] = Plugin.find(plugins_common[i]).plugin_name
      end
      plugin_1 = plugin_1 - plugins_common
      plugin_2 = plugin_2 - plugins_common

      theme_1 = JSON.parse( data_1.themes )
      theme_2 = JSON.parse( data_2.themes )
      themes_common = theme_1 & theme_2
      theme_1 = theme_1 - themes_common
      theme_2 = theme_2 - themes_common

      js_1 = JSON.parse( data_1.js )
      js_2 = JSON.parse( data_2.js )
      js_common = js_1 & js_2
      js_1 = js_1 - js_common
      js_2 = js_2 - js_common
  
      data_1 = {:login_url => data_1.login_url, :cloudflare => data_1.cloudflare, :cms_version => data_1.cms_version, :plugin => plugin_1, :theme => theme_1, :js => js_1} 
      data_2 = {:login_url => data_2.login_url, :cloudflare => data_2.cloudflare, :cms_version => data_2.cms_version, :plugin => plugin_2, :theme => theme_2, :js => js_2}
      data_common = {:plugin => plugins_common, :theme => themes_common, :js => js_common}
    
      render :partial => "diff", :locals => {:data => {:data_1 => data_1, :data_2 => data_2, :data_common => data_common}}
    end
  end
end 
