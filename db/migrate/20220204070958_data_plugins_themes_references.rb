class DataPluginsThemesReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :data, :plugins, foreign_key: true
    add_reference :data, :themes, foreign_key: true
  end
end
