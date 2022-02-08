class AddIndexToTest < ActiveRecord::Migration[5.2]
  def change
    add_index :tests, [:t_no,:site_data_id], unique: true
  end
end
