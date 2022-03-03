class AddTestIdToPlginsThemesJsInfos < ActiveRecord::Migration[5.2]
  def change
    add_column :plugins, :test_id, :string
    add_column :themes, :test_id, :string
    add_column :js_infos, :test_id, :string

  end
end
