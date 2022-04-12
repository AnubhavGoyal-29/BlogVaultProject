ActiveAdmin.register_page "main_page" do
  page_action :history, :method => [:post, :get]
  page_action :cms, :method => [:post, :get] 
  page_action :site_timeline, :method => [:post, :get]

end
