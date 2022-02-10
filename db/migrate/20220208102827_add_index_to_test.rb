class AddIndexToTest < ActiveRecord::Migration[5.2]
  def change
    add_index :test_data_infos, [:t_no,:url_id], unique: true
  end
end
