class CreatePlugins < ActiveRecord::Migration[5.2]
  def change
    create_table :plugins do |t|
      t.string :plugin_name
      t.string :url_id
      t.string :status
      t.string :type
      t.string :version
      t.string :other_data
      t.timestamps
    end
  end
end
