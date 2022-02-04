class RemoveReferences < ActiveRecord::Migration[5.2]
  def change
    remove_reference :urls, :tests, index: true, foreign_key: true
    remove_reference :plugins, :urls, index: true, foreign_key: true
    remove_reference :themes, :urls, index: true, foreign_key: true
    remove_reference :data, :plugins, index: true, foreign_key: true
    remove_reference :data, :themes, index: true, foreign_key: true
    remove_reference :tests, :data, index: true, foreign_key: true

  end
end
