class CreateAllReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :urls, :test, index: true, foreign_key: true
    add_reference :tests, :site_data, index: true, foreign_key: true
  
  end
end
