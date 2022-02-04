class AddReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :tests, :site_data, index: true, foreign_key: true
  end
end
