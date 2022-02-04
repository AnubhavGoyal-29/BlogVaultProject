class RemoveExtraColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :themes, :url_id
  end
end
