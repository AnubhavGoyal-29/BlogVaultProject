class RemoveLastTest < ActiveRecord::Migration[5.2]
  def change
    remove_column :urls, :last_test
  end
end
