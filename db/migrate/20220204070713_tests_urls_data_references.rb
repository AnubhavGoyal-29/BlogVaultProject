class TestsUrlsDataReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :tests, :data, foreign_key: true
    add_reference :tests, :urls, foreign_key: true
  end
end
