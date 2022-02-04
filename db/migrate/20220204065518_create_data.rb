class CreateData < ActiveRecord::Migration[5.2]
  def change
    create_table :data do |t|
      t.string :cms_type
      t.string :cms_version
      t.string :js
      t.string :cloudflare
      t.string :login_url
      t.string :hosting

      t.timestamps
    end
  end
end
