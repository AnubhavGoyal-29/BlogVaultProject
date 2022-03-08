class CreateSiteDataInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :site_data_infos do |t|
      t.string :url_id
      t.string :test_id
      t.string :cms_type
      t.string :cms_version
      t.text :js
      t.boolean :cloudflare
      t.string :login_url
      t.string :host_name
      t.string :ip
      t.text :plugins
      t.text :themes
      t.timestamps
    end
  end
end
