ActiveAdmin.register_page "main_page" do
  content do
    text_node javascript_include_tag 'https://www.gstatic.com/charts/loader.js', skip_pipeline: true
    panel "View Page" do
      render :partial => "form"
    end
  end

  page_action :compare_test, :method => [:post, :get] do
    flash[:notice] = params
    redirect_to admin_main_page_path
  end
end
