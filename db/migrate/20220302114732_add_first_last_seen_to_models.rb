class AddFirstLastSeenToModels < ActiveRecord::Migration[5.2]
  def change
    remove_column :plugins, :first_seen
    remove_column :plugins, :last_seen
    remove_column :themes, :first_seen
    remove_column :themes, :last_seen
    remove_column :js_infos, :first_seen
    remove_column :js_infos, :last_seen
    add_column :plugins, :first_seen, :integer
    add_column :themes, :first_seen, :integer
    add_column :js_infos, :first_seen, :integer
    add_column :plugins, :last_seen, :integer
    add_column :themes, :last_seen, :integer
    add_column :js_infos, :last_seen, :integer
  end
end
