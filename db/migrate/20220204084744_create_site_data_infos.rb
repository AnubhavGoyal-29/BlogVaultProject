class CreateSiteDataInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :site_data_infos do |t|
      t.string :website_id
      t.string :test_id
      t.string :cms_type
      t.string :cms_version
      t.text :js_ids
      t.boolean :cloudflare
      t.string :login_url
      t.string :host_name
      t.string :ip
      t.text :plugin_ids
      t.text :theme_ids
      t.timestamps
    end
  end
end
