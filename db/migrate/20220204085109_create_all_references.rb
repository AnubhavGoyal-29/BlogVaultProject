class CreateAllReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :urls, :test, index: true, foreign_key: true
    add_reference :tests, :datum, index: true, foreign_key: true
    add_reference :tests, :url, index: true, foreign_key: true
    add_reference :data, :theme, index: true, foreign_key: true
    add_reference :data, :plugin, index: true, foreign_key: true
  end
end
