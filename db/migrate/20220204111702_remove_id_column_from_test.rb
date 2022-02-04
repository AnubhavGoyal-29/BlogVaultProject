class RemoveIdColumnFromTest < ActiveRecord::Migration[5.2]
  def change
    remove_column :tests, :id
  end
end
