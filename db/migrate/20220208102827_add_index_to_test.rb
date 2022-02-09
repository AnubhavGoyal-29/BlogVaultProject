class AddIndexToTest < ActiveRecord::Migration[5.2]
  def change
    add_index :tests, [:t_no,:url_id], unique: true
  end
end
