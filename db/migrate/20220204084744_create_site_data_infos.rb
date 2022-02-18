class CreateSiteDataInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :site_data_infos do |t|
      t.string :url_id
      t.string :test_id
      t.string :cms_type
      t.string :cms_version
      t.string :js
      t.string :cloudflare
      t.string :login_url
      t.string :host_name
      t.string :plugins
      t.string :themes
      t.timestamps
    end
  end
end
