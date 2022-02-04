class RemoveColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :plugins, :url_id
  end
end
