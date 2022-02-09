class AddVersionColumnInPlugins < ActiveRecord::Migration[5.2]
  def change
    add_column :plugins, :version, :string
  end
end
