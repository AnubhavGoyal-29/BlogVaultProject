ActiveAdmin.register_page "main_page" do

  content do
    panel "View Page" do
      render :partial => "form"
    end
  end

  page_action :compare_test, :method => [:post, :get] do
    flash[:notice] = params
    redirect_to admin_main_page_path
  end
end
