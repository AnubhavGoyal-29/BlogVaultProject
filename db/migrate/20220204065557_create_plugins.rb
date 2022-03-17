class CreatePlugins < ActiveRecord::Migration[5.2]
  def change
    create_table :plugins do |t|
      t.string :plugin_name
      t.string :plugin_slug
      t.string :url_id
      t.boolean :status
      t.string :type
      t.string :version
      t.string :other_data
      t.integer :first_test
      t.integer :last_test
      t.timestamps
    end
  end
end
