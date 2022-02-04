class RemoveUrlidDataid < ActiveRecord::Migration[5.2]
  def change
    remove_column :tests, :url_id
    remove_column :tests, :data_id
  end
end
