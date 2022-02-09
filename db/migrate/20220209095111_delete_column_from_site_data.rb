class DeleteColumnFromSiteData < ActiveRecord::Migration[5.2]
  def change
    remove_reference :site_data, :plugin
    remove_reference :site_data, :theme
  end
end
