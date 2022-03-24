ActiveAdmin.register_page "v2_websites" do

  content do
    table_for V2::Website.all do
      column :id
      column :url
      column :url
    end
  end
end
