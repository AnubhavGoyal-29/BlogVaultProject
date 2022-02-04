class CreatePlugins < ActiveRecord::Migration[5.2]
  def change
    create_table :plugins do |t|
      t.string :plugin_name
      t.string :url_id
      t.string :status

      t.timestamps
    end
  end
end
