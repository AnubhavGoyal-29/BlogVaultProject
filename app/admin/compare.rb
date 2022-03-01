ActiveAdmin.register_page "Compare" do


  page_action :test_method, :method => [:get, :post] do
    if params[:_method] == "get"
      flash[:notice] = params
      #redirect_to admin_compare_path
      render :partial => "form", :locals => { :url_id => params[:url_id] }
    else
      flash[:notice] = params
      render :partial => "table"
      redirect_to admin_compare_path
    end
  end
end 
