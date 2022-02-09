class DataPluginsThemesReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :site_data, :plugin,index:true, foreign_key: true
    add_reference :site_data, :theme,index:true, foreign_key: true
  end
end
