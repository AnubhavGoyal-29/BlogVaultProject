class PluginsUrlReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :plugins, :url, foreign_key: true
  end
end
